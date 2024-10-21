import React, { FC, HTMLAttributes } from "react";
import { Link } from "react-router-dom";

// Internal component imports
import { Container, Content, Copyright, Column, Image } from "./styles";

import restaurant from "../../assets/restaurant.jpg";

const Footer: FC<HTMLAttributes<HTMLElement>> = (props): JSX.Element => {
  return (
    <Container {...props}>
      <Content>
        <Image src={restaurant} alt="Restaurant Food" />
        <Column>
          <h4>
            Little Lemon
          </h4>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/#">Menu</Link>
            </li>
            <li>
              <Link to="/bookings">Reservations</Link>
            </li>
            <li>
              <Link to="/#">Order Online</Link>
            </li>
            <li>
              <Link to="/#">Login</Link>
            </li>
          </ul>
        </Column>
        <Column>
          <h4>Contact</h4>
          <ul>
            <li>
              <address>
                Little Lemon <br />
                331 E Chicago <br />
                LaSalle Street Chicago, <br />
                Illinois 60602 <br />
                USA
              </address>
            </li>
          </ul>
        </Column>
        <Column>
          <h4>Follow Us</h4>
          <ul>
            <li>
              <a
                href="https://x.com"
                target="_blank"
                rel="noopener noreferrer"
              >
                X
              </a>
            </li>
            <li>
              <a
                href="https://facebook.com"
                target="_blank"
                rel="noopener noreferrer"
              >
                Facebook
              </a>
            </li>
            <li>
              <a
                href="https://instagram.com"
                target="_blank"
                rel="noopener noreferrer"
              >
                Instagram
              </a>
            </li>
          </ul>
        </Column>
      </Content>
      <Copyright>
        <p>&copy; 2024 Little Lemon. All rights reserved.</p>
      </Copyright>
    </Container>
  );
};

export default Footer;