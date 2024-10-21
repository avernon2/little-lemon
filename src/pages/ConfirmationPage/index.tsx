import React, { FC } from "react";

// Internal component imports
import Header from "../../components/Header";
import ConfirmedBooking from "../../components/ConfirmedBooking";
import Footer from "../../components/Footer";

// Style imports
import { Container } from "./styles";

const ConfirmationPage: FC = (): JSX.Element => {
  return (
    <Container>
      <Header />
      <ConfirmedBooking />
      <Footer />
    </Container>
  );
};

export default ConfirmationPage;