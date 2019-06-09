import React, { useState, useEffect } from 'react';

import { RouteComponentProps } from 'react-router-dom';

import {
  Button,
  Container,
  Grid,
  Icon,
  Menu,
  Modal,
  Table,
  Search,
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
  // const { user } = location.state;
  const [userId, setUserId] = useState<number>(1);
  const [state, setState] = useState<DashboardState>({
    transactions: []
  });

  useEffect(() => {
    fetch(`/api/users/${userId}/transactions`)
      .then(res => res.json())
      .then(body =>
        body.data.filter(
          (transaction: { amount: number }) => !!transaction.amount
        )
      )
      .then(txs => {
        setState({ transactions: txs });
      });
  }, [userId]);

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

  return (
    <Container>
      <Menu
        secondary
        color="blue"
        style={{ padding: '1em', fontSize: '1.2em' }}
      >
        <Menu.Item position="left" name="Budgetr" />
        <Menu.Menu position="right">
          <Menu.Item>
            <Button primary>
              <Icon name="sign-out" />
              Sign Out
            </Button>
          </Menu.Item>
        </Menu.Menu>
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
      <Grid>
        <Grid.Column width={8} float="left">
          <Search />
        </Grid.Column>
      </Grid>
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
              <Button secondary>
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
                onClose={() => {
                  console.log('onClose');
                }}
              >
                <Modal.Header>Add a Transaction</Modal.Header>
                <Modal.Content>
                  <AddTransactionForm
                    userId={1}
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
