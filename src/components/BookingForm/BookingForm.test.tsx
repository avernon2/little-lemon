import React from 'react';
import { render, screen } from '@testing-library/react';
import BookingForm from './index';
import { initializeTimes, updateTimes, fetchAPI } from '../../utils/temp';

describe('BookingForm', () => {
  test('Renders labels and fields', () => {
    render(
      <BookingForm
        availableTimes={{
          times: ['17:00', '18:00', '19:00', '20:00', '21:00', '22:00'],
        }}
        dispatch={jest.fn((action) => action)}
      />
    );

    // Date label and field
    const choseDateLabel = screen.getByText('Choose date');
    expect(choseDateLabel).toBeInTheDocument();
    const choseDateField = screen.getByTestId('res-date');
    expect(choseDateField).toBeInTheDocument();

    // Time label and field
    const choseTimeLabel = screen.getByText('Choose time');
    expect(choseTimeLabel).toBeInTheDocument();
    const choseTimeField = screen.getByTestId('res-time');
    expect(choseTimeField).toBeInTheDocument();

    // Number of guests label and field
    const numberGuestLabel = screen.getByText('Number of guests');
    expect(numberGuestLabel).toBeInTheDocument();
    const numberGuestField = screen.getByTestId('guests');
    expect(numberGuestField).toBeInTheDocument();

    // Occasion label and field
    const occasionLabel = screen.getByText('Occasion');
    expect(occasionLabel).toBeInTheDocument();
    const occasionField = screen.getByTestId('occasion');
    expect(occasionField).toBeInTheDocument();
  });

  test('initializeTimes returns the correct expected value', () => {
    const today = new Date();
    const initialState = initializeTimes();
    const expectedResult = { times: fetchAPI(today) };
    expect(initialState).toEqual(expectedResult);
  });

  test('updateTimes returns the updated state', () => {
    const state = {
      times: ['17:00', '18:00', '19:00', '20:00', '21:00', '22:00'],
    };
    const action = { type: 'UPDATE_TIMES', date: new Date() };
    const newState = updateTimes(state, action);
    expect(newState).toEqual({ times: fetchAPI(action.date) });
  });
});