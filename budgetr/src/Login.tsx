import React, { useState } from 'react';
import { Redirect } from 'react-router-dom';

import { Message } from 'semantic-ui-react';

import { GoogleLogin } from 'react-google-login';

type LoginErrorProps = { error: Partial<Error> };

const LoginError = ({ error }: LoginErrorProps) => (
  <Message negative>
    <Message.Header>Error logging in!</Message.Header>
    <p>{error.message || 'unknown error, please check console'}</p>
  </Message>
);

interface LoginState {
  error: Error | null;
  profile?: any;
}

export const Login: React.FC = () => {
  const [loginState, setState] = useState<LoginState>({
    error: null
  });

  const success = (result: any) => {
    const { profileObj } = result;
    const { email, familyName, givenName, googleId } = profileObj;
    fetch('/api/users/fetch', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email })
    })
      .then(res => {
        if (!res.ok && res.status === 404) {
          return fetch('/api/users', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              user: {
                email,
                first_name: givenName,
                last_name: familyName,
                external_id: googleId
              }
            })
          }).then(res => res.json());
        }

        return res.json();
      })
      .then((res: { data: any }) => {
        const user = res.data;
        setState({
          profile: user,
          error: null
        });
      });
  };

  const failure = (error: Error) => {
    console.error('google login error', error);
    setState({ error });
  };

  if (loginState.profile) {
    return (
      <Redirect
        to={{
          pathname: '/dashboard',
          state: { user: loginState.profile }
        }}
      />
    );
  }

  return (
    <>
      <GoogleLogin
        clientId={process.env.REACT_APP_GOOGLE_CLIENT_ID || ''}
        buttonText="Login with Google"
        cookiePolicy="single_host_origin"
        onSuccess={success}
        onFailure={failure}
      />
      {loginState.error ? <LoginError error={loginState.error} /> : null}
    </>
  );
};

export default Login;
