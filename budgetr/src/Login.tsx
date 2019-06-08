import React, { useState } from 'react'
import { Container, Message } from 'semantic-ui-react'
import { GoogleLogin } from 'react-google-login'

type LoginErrorProps = { error: Partial<Error> }

const LoginError = ({ error }: LoginErrorProps) => (
  <Message negative>
    <Message.Header>Error logging in!</Message.Header>
    <p>{error.message || 'unknown error, please check console'}</p>
  </Message>
)

interface LoginState {
  error: Error | null,
  profile?: any,
}

export const Login: React.FC = () => {
  const [loginState, setState] = useState<LoginState>({
    error: null,
  })

  const success = (result: any) => {
    setState({
      profile: result.profileObj,
      error: null,
    })
  }

  const failure = (error: Error) => {
    console.error('google login error', error)
    setState({ error })
  };

  if (loginState.profile) {
    return (
      <p>Welcome back, {loginState.profile.givenName}!</p>
    )
  }

  return (
    <Container>
      <GoogleLogin
        clientId={process.env.REACT_APP_GOOGLE_CLIENT_ID || ''}
        buttonText="Login with Google"
        cookiePolicy='single_host_origin'
        onSuccess={success}
        onFailure={failure}
      />
      { loginState.error ? <LoginError error={loginState.error} /> : null }
    </Container>
  )
}

export default Login
