module.exports = {
  env: {
    browser: true,
    es2021: true,
    jquery: true
  },
  extends: [
    'airbnb-base',
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'max-len': ['error', 120],
    "prefer-destructuring": ["error", {"object": true, "array": false}]
  },
};
