import React from 'react';
import { render } from '@testing-library/react';
import '@testing-library/jest-dom/extend-expect'; // for the "toBeInTheDocument" matcher
import App from './App';

test('renders App component', () => {
  const {container} = render(<App />);
  expect(container).toBeInTheDocument();
});