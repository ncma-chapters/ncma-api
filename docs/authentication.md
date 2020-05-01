# Authentication

## Authentication Workflow

We use AWS cognito as an identity service for authentication.

### Setup

- Install the `amazon-cognito-identity-js` npm package

- Find the `userPoolId` and `clientId` for the related AWS User Pool

### How to
```js
const login = (username, password) => {
	// Amazon Cognito creates a session which includes the id, access, and refresh tokens of an authenticated user.
	const userPoolId = 'us-east-1_abcXYZ';
	const clientId = '1235abcd';

	const authenticationData = { Username: username, Password: password };
	const authenticationDetails = new AmazonCognitoIdentity.AuthenticationDetails(authenticationData);

	const poolData = { UserPoolId: userPoolId, ClientId: clientId };
	const userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

	const userData = { Username: username, Pool: userPool };
	const cognitoUser = new AmazonCognitoIdentity.CognitoUser(userData);

	cognitoUser.authenticateUser(authenticationDetails, {
	    onSuccess: function (result) {
	      const accessToken = result.getAccessToken().getJwtToken();

	      /* Use the idToken for Logins Map when Federating User Pools with identity pools or when passing through an Authorization Header to an API Gateway Authorizer */
	      const idToken = result.idToken.jwtToken;
	      console.info(idToken);
	    },
	    onFailure: function(err) {
	      console.info(err);
	    },
	});
};

login(username, password);
```

## Error Handling

The API is built to respond with parsable errors for `401` and `403` statuses so you can inform the end-user and handle the error when possible.

### 401
<!-- TODO add examples -->

### 403
<!-- TODO add examples -->
