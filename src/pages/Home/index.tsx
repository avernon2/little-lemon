import React, { FC } from "react";

// Internal component imports
import Header from "../../components/Header";
import CallToAction from "../../components/CallToAction";
import Specials from "../../components/Specials";
import CustomersSay from "../../components/CustomersSay";
import Chicago from "../../components/Chicago";
import Footer from "../../components/Footer";

// Style imports
import { Container } from "./styles";

const Home: FC = (): JSX.Element => {
  return (
    <Container>
      <Header />
      <CallToAction />
      <Specials />
      <CustomersSay />
      <Chicago />
      <Footer />
    </Container>
  );
};

export default Home;