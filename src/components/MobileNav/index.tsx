import React, { useState, useCallback, FC, HTMLAttributes } from "react";
import { Link } from "react-router-dom";

// Internal component imports
import { Container, Menu } from "./styles";

// Asset imports
import logoImg from "../../assets/logo.svg";
import hamburgerIcon from "../../assets/hamburgerIcon.svg";
import shoppingCart from "../../assets/shoppingCartOutline.svg";
import closeImg from "../../assets/close.svg";

const MobileNav: FC<HTMLAttributes<HTMLElement>> = (props): JSX.Element => {
  const [menuOpen, setMenuOpen] = useState(false);

  const handleMenu = useCallback(() => {
    setMenuOpen(prevValue => !prevValue);
  }, []);

  return (
    <Container {...props}>
      <ul>
        <li>
          <button type="button" aria-label="Open menu" onClick={handleMenu}>
            <img src={hamburgerIcon} alt="Open menu" />
          </button>
        </li>
        <li>
          <img className="shoppingCart" src={shoppingCart} alt="Shopping Cart" />
        </li>
      </ul>

      <Menu className={menuOpen ? "opened" : ""}>
        <button type="button" aria-label="Close menu" onClick={handleMenu}>
          <img src={closeImg} alt="Close menu" />
        </button>
        <ul>
          <li>
            <img src={logoImg} alt="Little Lemon Logo" />
          </li>
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="#about">About</Link>
          </li>
          <li>
            <Link to="#menu">Menu</Link>
          </li>
          <li>
            <Link to="/bookings">Reservations</Link>
          </li>
          <li className="orderBtn">
            <Link role="button" to="#">
              Order Online
            </Link>
          </li>
        </ul>
      </Menu>
    </Container>
  );
};

export default MobileNav;