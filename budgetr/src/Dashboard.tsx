import React, { useState, useEffect, useRef } from 'react';

import { RouteComponentProps } from 'react-router-dom';

import {
  Button,
  Container,
  Icon,
  Menu,
  Modal,
  Table,
  Segment,
  StatisticGroup,
  Statistic
} from 'semantic-ui-react';

import { AddTransactionForm } from './AddTransactionForm';

interface DashboardState {
  transactions: any[];
}

export const Dashboard: React.FC<RouteComponentProps> = ({
  location
}: RouteComponentProps) => {
  const { user } = location.state;
  const userId = user.id;
  const [transactionsUrl, setTransactionsUrl] = useState<string>(
    `/api/users/${userId}/transactions`
  );
  const [state, setState] = useState<DashboardState>({
    transactions: []
  });

  const fileInputRef = useRef<HTMLInputElement>(null);
  const onUploadClicked = () => {
    if (fileInputRef && fileInputRef.current) {
      fileInputRef.current.click();
    }
  };

  const uploadFile = (files: FileList | null) => {
    if (typeof files === 'undefined' || files === null) {
      return;
    }
    const file = files[0];
    const formData = new FormData();
    formData.append('transactions', file);
    fetch('/api/transactions/bulk', {
      method: 'POST',
      body: formData
    }).then(() => {
      setTransactionsUrl(`api/users/${userId}/transactions`);
    });
  };

  useEffect(() => {
    fetch(transactionsUrl)
      .then(res => res.json())
      .then(body =>
        body.data.filter(
          (transaction: { amount: number }) => !!transaction.amount
        )
      )
      .then(txs => {
        setState({ transactions: txs });
      });
  }, [transactionsUrl]);

  const renderTransactionRow = (
    { description, category, amount, datetime_occurred }: any,
    index: number
  ) => {
    return (
      <Table.Row key={index}>
        <Table.Cell>{description}</Table.Cell>
        <Table.Cell>{category}</Table.Cell>
        <Table.Cell>{amount / 100}</Table.Cell>
        <Table.Cell>
          {new Date(datetime_occurred).toLocaleString('en-US')}
        </Table.Cell>
      </Table.Row>
    );
  };

  const clientId = `${process.env.REACT_APP_GOOGLE_CLIENT_ID}`;
  return (
    <Container>
      <Menu
        secondary
        color="blue"
        style={{ padding: '1em', fontSize: '1.2em' }}
      >
        <Menu.Item position="left" name="Budgetr" />
        <Menu.Item
          position="right"
          name={`${user.first_name} ${user.last_name}`}
        />
      </Menu>
      <Segment>
        <StatisticGroup widths="2">
          <Statistic color="green">
            <Statistic.Value>$1,766</Statistic.Value>
            <Statistic.Label>Amount Remaining</Statistic.Label>
          </Statistic>
          <Statistic color="blue">
            <Statistic.Value>25</Statistic.Value>
            <Statistic.Label>Transactions this month</Statistic.Label>
          </Statistic>
        </StatisticGroup>
      </Segment>
      <Table celled padded selectable sortable color="blue">
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Description</Table.HeaderCell>
            <Table.HeaderCell>Category</Table.HeaderCell>
            <Table.HeaderCell>Amount</Table.HeaderCell>
            <Table.HeaderCell>Date Occurred</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>{state.transactions.map(renderTransactionRow)}</Table.Body>
        <Table.Footer fullWidth>
          <Table.Row>
            <Table.HeaderCell colSpan="4">
              <Button secondary onClick={onUploadClicked}>
                <input
                  type="file"
                  ref={fileInputRef}
                  style={{ display: 'none' }}
                  onChange={e => uploadFile(e.target.files)}
                />
                <Icon name="upload" />
                Bulk Upload
              </Button>
              <Modal
                trigger={
                  <Button primary floated="right">
                    <Icon name="plus" />
                    Add Transaction
                  </Button>
                }
              >
                <Modal.Header>Add a Transaction</Modal.Header>
                <Modal.Content>
                  <AddTransactionForm
                    userId={userId}
                    onTransactionAdded={(tx: any) => {
                      setState({
                        transactions: [tx, ...state.transactions]
                      });
                    }}
                  />
                </Modal.Content>
              </Modal>
            </Table.HeaderCell>
          </Table.Row>
        </Table.Footer>
      </Table>
    </Container>
  );
};
