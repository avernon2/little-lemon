import React, { FC, HTMLAttributes, useRef, useState, useEffect, useCallback, MutableRefObject } from "react";

// Internal component imports
import Nav from "../Nav";
import MobileNav from "../MobileNav";

// Style imports
import { Container, Content } from "./styles";

const Header: FC<HTMLAttributes<HTMLElement>> = (props): JSX.Element => {
  const headerRef: MutableRefObject<HTMLElement | null> = useRef(null);
  const [, setLastScrollPosition] = useState(window.scrollY || document.documentElement.scrollTop);

  const handleScroll = useCallback(() => {
    const header = headerRef.current;
    const scrollPosition = window.scrollY || document.documentElement.scrollTop;

    setLastScrollPosition((prevState) => {
      if (!header) return scrollPosition > 0 ? scrollPosition : 0;

      if (scrollPosition > prevState) {
        header.style.transform = "translateY(-200px)";
      } else {
        header.style.transform = "translateY(0)";
      }
      return scrollPosition > 0 ? scrollPosition : 0;
    });
  }, []);

  useEffect(() => {
    window.addEventListener("scroll", handleScroll);

    return () => window.removeEventListener("scroll", handleScroll);
  }, [handleScroll]);

  return (
    <Container {...props} ref={headerRef}>
      <Content>
        <Nav />
        <MobileNav />
      </Content>
    </Container>
  );
};

export default Header;