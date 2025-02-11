/* eslint-disable import/no-extraneous-dependencies */
import eslint from '@eslint/js';
import { FlatCompat } from '@eslint/eslintrc';
import globals from 'globals';

const compat = new FlatCompat({
  // import.meta.dirname is available after Node.js v20.11.0
  baseDirectory: import.meta.dirname,
  recommendedConfig: eslint.configs.recommended,
});

const eslintConfig = [
  ...compat.config({
    extends: [
      'airbnb-base',
      'eslint:recommended',
      'plugin:json/recommended-legacy',
      'prettier',
    ],
    parser: '@babel/eslint-parser',
    parserOptions: {
      allowImportExportEverywhere: true,
      requireConfigFile: false,
      sourceType: 'module',
    },
    plugins: ['sort-keys', 'prettier'],
    rules: {
      'import/extensions': ['error', { js: 'always' }],
      'import/prefer-default-export': 0,
      'linebreak-style': ['error', 'unix'],
      'max-classes-per-file': [1],
      'no-console': [
        1,
        {
          allow: ['error', 'warn', 'info'],
        },
      ],
      'no-param-reassign': [
        2,
        {
          props: false,
        },
      ],
      'no-plusplus': [
        2,
        {
          allowForLoopAfterthoughts: true,
        },
      ],
      'prefer-template': 'error',
      'prettier/prettier': ['error'],
      'sort-keys': 0,
      'sort-keys/sort-keys-fix': 2,
    },
  }),
  { ignores: ['data/web-resources/js/autocomplete-js.js', 'data/web-resources/js/glide.min.js'] },
  {
    files: ['**/*.json', '**/*.js', '**.*.mjs'],
  },
  {
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.browser,
      },
    },
  },
];

export default eslintConfig;
