import React from 'react'

import { RouteComponentProps } from 'react-router-dom'

import {
  Button,
  Container,
  Grid,
  Header,
  Icon,
  Pagination,
  Table,
  Search,
  Segment,
  StatisticGroup,
  Statistic,
} from 'semantic-ui-react'

export const Dashboard = ({ location }: RouteComponentProps) => {
  const { user } = location.state

  return (
    <Container>
      <div style={{margin: '1rem'}}>
        <Header as='h2'>Welcome back, {user.name}!</Header>
      </div>
      <Segment>
        <StatisticGroup widths='2'>
          <Statistic color='green'>
            <Statistic.Value>$1,766</Statistic.Value>
            <Statistic.Label>Amount Remaining</Statistic.Label>
          </Statistic>
          <Statistic color='blue'>
            <Statistic.Value>25</Statistic.Value>
            <Statistic.Label>Transactions this month</Statistic.Label>
          </Statistic>
        </StatisticGroup>
      </Segment>
      <Grid>
        <Grid.Column width={8} float='left'>
          <Search />
        </Grid.Column>
      </Grid>
      <Table celled padded selectable color='blue'>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>Description</Table.HeaderCell>
            <Table.HeaderCell>Category</Table.HeaderCell>
            <Table.HeaderCell>Amount</Table.HeaderCell>
            <Table.HeaderCell>Date Occurred</Table.HeaderCell>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          <Table.Row>
            <Table.Cell>Fancy Coffee</Table.Cell>
            <Table.Cell>Food</Table.Cell>
            <Table.Cell>Amount</Table.Cell>
            <Table.Cell>June 6, 2018 7:46 AM</Table.Cell>
          </Table.Row>
        </Table.Body>
        <Table.Footer fullWidth>
          <Table.Row>
            <Table.HeaderCell colSpan='4'>
              <Button secondary>
                <Icon name='upload' />
                Bulk Upload
              </Button>
              <Pagination 
                defaultActivePage={1}
                totalPages={3}
                style={{marginLeft: '0.5rem'}}
              />
              <Button primary floated='right'>
                <Icon name='plus' />
                Add Transaction
              </Button>
            </Table.HeaderCell>
          </Table.Row>
        </Table.Footer>
      </Table>
    </Container>
  )
}
