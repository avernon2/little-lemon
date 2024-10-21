import React, { useReducer, FC } from "react";

// Internal component imports
import Header from "../../components/Header";
import BookingForm from "../../components/BookingForm";
import Footer from "../../components/Footer";

// Utility imports
import { updateTimes, initializeTimes } from "../../utils/temp";

// Style imports
import { Container } from "./styles";

const BookingPage: FC = (): JSX.Element => {
  const [availableTimes, dispatch] = useReducer(updateTimes, initializeTimes());

  return (
    <Container>
      <Header />
      <BookingForm availableTimes={availableTimes} dispatch={dispatch} />
      <Footer />
    </Container>
  );
};

export default BookingPage;