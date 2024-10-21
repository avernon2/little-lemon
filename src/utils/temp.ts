const seededRandom = (seed: number) => {
  const m = 2 ** 35 - 31;
  const a = 185852;
  let s = seed % m;
  return function () {
    return (s = (s * a) % m) / m;
  };
};

export const fetchAPI = (date: Date): string[] => {
  const result: string[] = [];
  const random = seededRandom(date.getDate());

  for (let hour = 17; hour <= 23; hour++) {
    if (random() < 0.5) {
      result.push(`${hour}:00`);
    }
    if (random() < 0.5) {
      result.push(`${hour}:30`);
    }
  }
  return result;
};

export const submitAPI = (formData: { date: string; time: string; guests: number; occasion: string }): boolean => {
  console.log(formData);
  return true;
};

interface State {
  times: string[];
}

interface Action {
  type: string;
  date: Date;
}

export const updateTimes = (state: State, action: Action): State => {
  switch (action.type) {
    case "UPDATE_TIMES":
      return { ...state, times: fetchAPI(action.date) };
    default:
      return state;
  }
};

export const initializeTimes = (): State => {
  const today = new Date();
  return { times: fetchAPI(today) };
};