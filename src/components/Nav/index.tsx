import React, { FC, HTMLAttributes } from "react";
import { Link } from "react-router-dom";

// Internal component imports
import { Container } from "./styles";

// Asset imports
import logoImg from "../../assets/logo.svg";
import shoppingCart from "../../assets/shoppingCartOutline.svg";

const Nav: FC<HTMLAttributes<HTMLElement>> = (props): JSX.Element => {
  return (
    <Container {...props}>
      <ul>
        <li>
          <img src={logoImg} alt="Little Lemon Logo" />
        </li>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/#about">About</Link>
        </li>
        <li>
          <Link to="/#menu">Menu</Link>
        </li>
        <li>
          <Link to="/bookings">Reservations</Link>
        </li>
        <li className="orderBtn">
          <Link role="button" to="#">
            Order Online
          </Link>
        </li>
        <li>
          <img className="shoppingCart" src={shoppingCart} alt="Shopping Cart" />
        </li>
      </ul>
    </Container>
  );
};

export default Nav;