import React from 'react';

import * as yup from 'yup';
import * as formik from 'formik';

import { Form, Button, Icon } from 'semantic-ui-react';

interface FormValues {
  description: string;
  category: string;
  amount: number;
  userId: number | string;
}

const addTransactionSchema = yup.object().shape({
  description: yup
    .string()
    .max(50, 'Description is too long')
    .required('Required'),
  category: yup
    .string()
    .max(25, 'Category is too long')
    .required('Required'),
  amount: yup
    .number()
    .round('round')
    .required()
});

const InnerForm = (props: formik.FormikProps<FormValues>) => {
  const { isSubmitting, touched, errors, handleSubmit } = props;
  return (
    <Form as={formik.Form} onSubmit={handleSubmit}>
      <Form.Input
        control={formik.Field}
        label="Description"
        name="description"
      />
      {touched.description && errors.description && (
        <div style={{ color: 'red' }}>{errors.description}</div>
      )}
      <Form.Input control={formik.Field} label="Category" name="category" />
      {touched.category && errors.category && (
        <div style={{ color: 'red' }}>{errors.category}</div>
      )}
      <Form.Input
        control={formik.Field}
        type="number"
        label="Amount"
        name="amount"
      />
      {touched.amount && errors.amount && (
        <div style={{ color: 'red' }}>{errors.amount}</div>
      )}
      <Button type="submit" primary disabled={isSubmitting}>
        <Icon name="plus" />
        Add Transaction
      </Button>
    </Form>
  );
};

export const AddTransactionForm = formik.withFormik<
  { userId: number | string; onTransactionAdded: (transaction: any) => void },
  FormValues
>({
  mapPropsToValues: ({ userId }) => ({
    description: '',
    category: '',
    amount: 0,
    userId
  }),
  validationSchema: addTransactionSchema,
  handleSubmit: (values, { setSubmitting, props }) => {
    const { userId, description, category, amount } = values;
    const { onTransactionAdded } = props;
    fetch(`/api/users/${userId}/transactions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        transaction: {
          user_id: userId,
          amount: Math.trunc(amount * 100),
          description,
          category,
          datetime_occurred: new Date().toISOString()
        }
      })
    })
      .then(res => res.json())
      .then(({ data }: { data: any }) => {
        setSubmitting(false);
        onTransactionAdded(data);
      });
  }
})(InnerForm);

export default AddTransactionForm;
