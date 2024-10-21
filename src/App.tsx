import React from 'react';
import './App.css';
import { Route, Routes } from 'react-router-dom';
import Home from './pages/Home';
import Bookingpage from './pages/Bookingpage';
import ConfirmationPage from './pages/ConfirmationPage';

function App() {
  return (
    <Routes>
      <Route element={<Home/>} path="/"/>
      <Route element={<Bookingpage/>} path="/bookings"/>
      <Route element={<ConfirmationPage/>} path="/confirmation"/>
    </Routes>
  );
}
export default App;
