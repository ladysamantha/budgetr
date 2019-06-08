import React from 'react';
import { BrowserRouter, Route } from 'react-router-dom';

import { Container } from 'semantic-ui-react';

import './App.css';
import { Login } from './Login';
import { Dashboard } from './Dashboard';

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Container>
        <Route exact path="/" component={Login} />
        <Route path="/dashboard" component={Dashboard} />
      </Container>
    </BrowserRouter>
  );
};

export default App;
