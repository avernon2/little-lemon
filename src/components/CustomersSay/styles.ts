import styled from "styled-components";
import { HTMLAttributes } from "react";

export const Container = styled.div<HTMLAttributes<HTMLDivElement>>`
  width: 70%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 4.3rem;
  padding-top: 4rem;
  padding-bottom: 2rem;
  padding-left: 1rem;
  padding-right: 1rem;
  background-color: rgba(251, 218, 187, .3); 

  ::before {
    content: '';
    width: 100%;
    height: 100vh;
    margin-bottom: -4rem;
    position: absolute;

    z-index: -1;

    @media (max-width: 1120px) {
      min-height: 100rem;
    };

    @media (max-width: 606px) {
      height: 190rem;
      min-height: 190rem;
    };
  };

  @media (max-width: 1120px) {
    width: 90%;
    min-height: 100rem;
  };

  @media (max-width: 606px) {
    height: 100%;
  };
`;

export const Title = styled.h2<HTMLAttributes<HTMLHeadingElement>>`
  width: 100%;
  height: auto;
  text-align: center;
`;

export const Cards = styled.div<HTMLAttributes<HTMLDivElement>>`
  width: 100%;
  height: fit-content;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 2rem;

  @media (max-width: 840px) {
    flex-wrap: wrap;
  };

  @media (max-width: 606px) {
    align-items: center;
    flex-direction: column;
  };
`;