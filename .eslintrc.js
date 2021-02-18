module.exports = {
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  extends: [
    'airbnb-base',
    'airbnb-typescript/base',
  ],
  parserOptions: {
    createDefaultProgram: true,
    project: './tsconfig.json',
  },
  rules: {
    'import/prefer-default-export': 0,
    'class-methods-use-this': 0,
    'no-restricted-syntax': 0,
    'no-plusplus': 0,
    'no-param-reassig': 0,
    'guard-for-in': 0,
    'no-continue': 0,
    'max-classes-per-file': 0,
    'no-underscore-dangle': 0,
    '@typescript-eslint/naming-convention': 0,
    'no-restricted-properties': 0,
    'no-mixed-operators': 0,
    '@typescript-eslint/no-shadow': 0,
    '@typescript-eslint/quotes': 0,
    'max-len': 0,
  },
};
