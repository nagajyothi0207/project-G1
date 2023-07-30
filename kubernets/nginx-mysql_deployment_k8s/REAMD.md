In JavaScript, you cannot directly access environment variables from the Linux operating system within your code. However, you can pass environment-specific values to your JavaScript code during the build or runtime process. Here are a few common methods to achieve this:

1. **Using Script Tags in HTML:**

In your HTML file, you can use script tags to set JavaScript variables that act as environment variables. For example:

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Web Page</title>
</head>
<body>
  <script>
    // Set your environment-specific values here
    let apiUrl = 'https://api.example.com';
  </script>
  <script src="your-script.js"></script>
</body>
</html>
```

Now, in `your-script.js`, you can access the `apiUrl` variable:

```javascript
// your-script.js
let apiUrl = 'default-value'; // A default value in case the script is loaded without environment-specific values
console.log(apiUrl); // Output: 'https://api.example.com'
```

2. **Using Webpack and Environment Variables:**

If you are using a build tool like Webpack, you can use environment-specific configuration files to pass values to your JavaScript code during the build process. Create different configuration files for each environment, e.g., `config.prod.js`, `config.dev.js`, etc.

```javascript
// config.prod.js
const apiUrl = 'https://api.example.com';
export default apiUrl;
```

In your build script, set the appropriate configuration file based on the environment you are building for.

Then, in your JavaScript file, you can import the configuration:

```javascript
// your-script.js
import apiUrl from './config';

console.log(apiUrl); // Output will be the value set in the configuration file for the corresponding environment.
```

3. **Using Server-Side Templating:**

If your JavaScript code is generated server-side (e.g., using a templating engine like Handlebars or EJS), you can inject environment-specific values directly into the template during rendering.

For example, in Node.js using Express and EJS:

```javascript
// server.js
const express = require('express');
const app = express();

// Set the view engine to EJS
app.set('view engine', 'ejs');

// Render the HTML page with environment-specific variables
app.get('/', (req, res) => {
  const apiUrl = 'https://api.example.com';
  res.render('index', { apiUrl });
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
```

And in your EJS template (`index.ejs`):

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Web Page</title>
</head>
<body>
  <script>
    let apiUrl = '<%= apiUrl %>';
    console.log(apiUrl); // Output: 'https://api.example.com'
  </script>
  <script src="your-script.js"></script>
</body>
</html>
```

Choose the method that best fits your application's architecture and needs. Remember that exposing sensitive information like passwords or API keys directly in your JavaScript code is not recommended. Always use appropriate security measures to protect sensitive data.