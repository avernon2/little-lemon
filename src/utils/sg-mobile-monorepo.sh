#!/bin/bash

# Create root directory
mkdir -p SG_MOBILE
cd SG_MOBILE

# Initialize the monorepo with npm
npm init -y

# Update package.json for workspaces
cat > package.json << 'EOL'
{
  "name": "secure-guardians",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "engines": {
    "node": ">=18.0.0"
  },
  "scripts": {
    "start:api": "npm run --workspace=@secure-guardians/api start",
    "start:app": "npm run --workspace=@secure-guardians/app start",
    "dev:api": "npm run --workspace=@secure-guardians/api dev",
    "build": "npm run --workspaces build",
    "lint": "npm run --workspaces lint"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^5.59.0",
    "@typescript-eslint/parser": "^5.59.0",
    "eslint": "^8.38.0",
    "prettier": "^2.8.7",
    "typescript": "^5.0.4"
  }
}
EOL

# Create workspace directories
mkdir -p packages/api
mkdir -p packages/app
mkdir -p packages/shared

# Create shared TypeScript config
cat > tsconfig.json << 'EOL'
{
  "compilerOptions": {
    "target": "es2022",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true
  }
}
EOL

# Create .gitignore
cat > .gitignore << 'EOL'
node_modules/
dist/
build/
coverage/
.env
.DS_Store
*.log
npm-debug.log*
android/
ios/
EOL

#
# Shared Package Setup
#
cd packages/shared

# Initialize shared package
cat > package.json << 'EOL'
{
  "name": "@secure-guardians/shared",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "engines": {
    "node": ">=18.0.0"
  },
  "scripts": {
    "build": "tsc",
    "lint": "eslint src --ext .ts"
  },
  "devDependencies": {
    "typescript": "^5.0.4"
  }
}
EOL

# Shared package TypeScript config
cat > tsconfig.json << 'EOL'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"]
}
EOL

# Create shared package source directory
mkdir -p src

# Create shared constants and interfaces
cat > src/index.ts << 'EOL'
// API routes
export const API_ROUTES = {
  HEALTH: '/health',
  // Add more routes as needed
};

// App routes/screens
export const APP_ROUTES = {
  HOME: 'Home',
  HEALTH_OVERVIEW: 'HealthOverview',
};

// Health Overview tabs
export const HEALTH_OVERVIEW_TABS = {
  OVERVIEW: 'Overview',
  CALENDAR: 'Calendar'
};

// Shared types
export interface HealthCheckStatus {
  status: 'ok' | 'error';
  timestamp: string;
  version: string;
}

// Service interfaces
export interface IHealthCheckService {
  getHealthCheckStatus(): HealthCheckStatus;
}
EOL

#
# API Package Setup
#
cd ../api

# Initialize API package with inversify for DI
cat > package.json << 'EOL'
{
  "name": "@secure-guardians/api",
  "version": "1.0.0",
  "engines": {
    "node": ">=18.0.0"
  },
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node-dev --respawn --transpile-only src/index.ts",
    "lint": "eslint src --ext .ts"
  },
  "dependencies": {
    "@secure-guardians/shared": "1.0.0",
    "cors": "^2.8.5",
    "dotenv": "^16.0.3",
    "express": "^4.18.2",
    "helmet": "^6.1.5",
    "inversify": "^6.0.1",
    "inversify-express-utils": "^6.4.3",
    "reflect-metadata": "^0.1.13",
    "swagger-jsdoc": "^6.2.8",
    "swagger-ui-express": "^4.6.2"
  },
  "devDependencies": {
    "@types/cors": "^2.8.13",
    "@types/express": "^4.17.17",
    "@types/node": "^18.17.0",
    "@types/swagger-jsdoc": "^6.0.1",
    "@types/swagger-ui-express": "^4.1.3",
    "ts-node-dev": "^2.0.0",
    "typescript": "^5.0.4"
  }
}
EOL

# API package TypeScript config
cat > tsconfig.json << 'EOL'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "types": ["reflect-metadata", "node"]
  },
  "include": ["src/**/*"]
}
EOL

# Create API source directories
mkdir -p src/controllers
mkdir -p src/services
mkdir -p src/types
mkdir -p src/config
mkdir -p src/middlewares
mkdir -p src/ioc

# Create .env file
cat > .env.example << 'EOL'
# Server Configuration
PORT=3000
NODE_ENV=development
API_VERSION=1.0.0
EOL

# Create IoC container setup
cat > src/ioc/container.ts << 'EOL'
import { Container } from 'inversify';
import { IHealthService } from '@health-overview/shared';
import { HealthService } from '../services/healthService';
import { TYPES } from './types';

const container = new Container();

// Services
container.bind<IHealthService>(TYPES.HealthService).to(HealthService);

export default container;
EOL

# Create IoC types
cat > src/ioc/types.ts << 'EOL'
export const TYPES = {
  HealthCheckService: Symbol.for('HealthCheckService')
};
EOL

# Create Swagger configuration
cat > src/config/swagger.ts << 'EOL'
import swaggerJSDoc from 'swagger-jsdoc';

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Health Overview API',
      version: process.env.API_VERSION || '1.0.0',
      description: 'API for Health Overview application',
    },
    servers: [
      {
        url: `http://localhost:${process.env.PORT || 3000}`,
        description: 'Development server',
      },
    ],
  },
  apis: ['./src/controllers/*.ts'], // Path to the API docs
};

const swaggerConfig = swaggerJSDoc(swaggerOptions);

export default swaggerConfig;
EOL

# Create health service
cat > src/services/healthCheckService.ts << 'EOL'
import { injectable } from 'inversify';
import { HealthCheckStatus, IHealthCheckService } from '@secure-guardians/shared';

@injectable()
export class HealthCheckService implements IHealthCheckService {
  public getHealthCheckStatus(): HealthCheckStatus {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      version: process.env.API_VERSION || '1.0.0'
    };
  }
}
EOL

# Create health controller using inversify-express-utils
cat > src/controllers/healthCheckController.ts << 'EOL'
import { inject } from 'inversify';
import { controller, httpGet } from 'inversify-express-utils';
import { Request, Response } from 'express';
import { API_ROUTES, IHealthCheckService } from '@secure-guardians/shared';
import { TYPES } from '../ioc/types';

/**
 * @swagger
 * /health:
 *   get:
 *     summary: Check API health status
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: API is healthy
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: ok
 *                 timestamp:
 *                   type: string
 *                   format: date-time
 *                 version:
 *                   type: string
 */
@controller('')
export class HealthCheckController {
  constructor(
    @inject(TYPES.HealthCheckService) private healthCheckService: IHealthCheckService
  ) {}

  @httpGet(API_ROUTES.HEALTH)
  public getHealth(req: Request, res: Response): void {
    const healthStatus = this.healthCheckService.getHealthCheckStatus();
    res.status(200).json(healthStatus);
  }
}
EOL

# Create main API file with inversify setup
cat > src/index.ts << 'EOL'
import 'reflect-metadata';
import { InversifyExpressServer } from 'inversify-express-utils';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import swaggerUI from 'swagger-ui-express';
import container from './ioc/container';
import swaggerConfig from './config/swagger';

// Import controllers (required for inversify-express-utils to find them)
import './controllers/healthController';

// Load environment variables
dotenv.config();

// Create inversify server
const server = new InversifyExpressServer(container);

server.setConfig((app) => {
  // Middleware
  app.use(cors());
  app.use(helmet());
  app.use(express.json());

  // Swagger Setup
  app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerConfig));
});

const app = server.build();
const port = process.env.PORT || 3000;

// Start server
app.listen(port, () => {
  console.log(`Health Overview API running on port ${port}`);
  console.log(`Swagger documentation available at http://localhost:${port}/api-docs`);
});

export default app;
EOL

#
# Mobile App Setup (React Native without Expo)
#
cd ../app

# Initialize React Native app
cat > package.json << 'EOL'
{
  "name": "@secure-guardians/app",
  "version": "1.0.0",
  "scripts": {
    "start": "react-native start",
    "android": "react-native run-android",
    "ios": "react-native run-ios",
    "lint": "eslint src --ext .ts,.tsx",
    "build": "tsc",
    "prepare": "node_modules/.bin/react-native run-android && node_modules/.bin/react-native run-ios"
  },
  "dependencies": {
    "@secure-guardians/shared": "1.0.0",
    "@react-navigation/bottom-tabs": "^6.5.7",
    "@react-navigation/native": "^6.1.6",
    "@react-navigation/native-stack": "^6.9.12",
    "axios": "^1.3.6",
    "react": "18.2.0",
    "react-native": "0.71.6",
    "react-native-safe-area-context": "4.5.0",
    "react-native-screens": "~3.20.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "@babel/preset-env": "^7.20.0",
    "@babel/runtime": "^7.20.0",
    "@react-native-community/eslint-config": "^3.2.0",
    "@tsconfig/react-native": "^2.0.2",
    "@types/jest": "^29.2.1",
    "@types/react": "^18.0.24",
    "@types/react-test-renderer": "^18.0.0",
    "babel-jest": "^29.2.1",
    "eslint": "^8.19.0",
    "jest": "^29.2.1",
    "metro-react-native-babel-preset": "0.73.9",
    "react-native-typescript-transformer": "^1.2.13",
    "react-test-renderer": "18.2.0",
    "typescript": "4.8.4"
  },
  "private": true
}
EOL

# React Native TypeScript config
cat > tsconfig.json << 'EOL'
{
  "extends": "@tsconfig/react-native/tsconfig.json",
  "compilerOptions": {
    "jsx": "react-native",
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true
  }
}
EOL

# Create React Native babel config
cat > babel.config.js << 'EOL'
module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
};
EOL

# Create metro.config.js
cat > metro.config.js << 'EOL'
const { getDefaultConfig } = require('metro-config');

module.exports = (async () => {
  const {
    resolver: { sourceExts, assetExts },
  } = await getDefaultConfig();
  return {
    transformer: {
      babelTransformerPath: require.resolve('react-native-typescript-transformer'),
      getTransformOptions: async () => ({
        transform: {
          experimentalImportSupport: false,
          inlineRequires: true,
        },
      }),
    },
    resolver: {
      sourceExts: [...sourceExts, 'ts', 'tsx'],
      assetExts: [...assetExts, 'png', 'jpg', 'jpeg'],
    },
  };
})();
EOL

# Create React Native source directories
mkdir -p src/screens
mkdir -p src/navigation
mkdir -p src/services
mkdir -p src/components
mkdir -p src/assets

# Create App.tsx
cat > src/App.tsx << 'EOL'
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { APP_ROUTES } from '@secure-guardians/shared';
import HomeScreen from './screens/HomeScreen';
import HealthOverviewNavigator from './navigation/HealthOverviewNavigator';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <SafeAreaProvider>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name={APP_ROUTES.HOME} component={HomeScreen} />
          <Stack.Screen 
            name={APP_ROUTES.HEALTH_OVERVIEW}
            component={HealthOverviewNavigator}
            options={{ title: "Health Overview" }}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
};

export default App;
EOL

# Create index.js (entry point)
cat > index.js << 'EOL'
import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';

AppRegistry.registerComponent(appName, () => App);
EOL

# Create app.json
cat > app.json << 'EOL'
{
  "name": "SecureGuardians",
  "displayName": "Secure Guardians"
}
EOL

# Create Tab Navigator
cat > src/navigation/TabNavigator.tsx << 'EOL'
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { APP_ROUTES } from '@secure-guardians/shared';
import OverviewScreen from '../screens/OverviewScreen';
import CalendarScreen from '../screens/CalendarScreen';

const Tab = createBottomTabNavigator();

const TabNavigator = () => {
  return (
    <Tab.Navigator screenOptions={{ headerShown: true }}>
      <Tab.Screen 
        name={APP_ROUTES.OVERVIEW} 
        component={OverviewScreen} 
      />
      <Tab.Screen 
        name={APP_ROUTES.CALENDAR} 
        component={CalendarScreen} 
      />
    </Tab.Navigator>
  );
};

export default TabNavigator;
EOL

# Create screens
mkdir -p src/screens

# Create Home Screen
cat > src/screens/HomeScreen.tsx << 'EOL'
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { APP_ROUTES } from '@secure-guardians/shared';

const HomeScreen = () => {
  const navigation = useNavigation();

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Secure Guardians</Text>
      <Text style={styles.subtitle}>Welcome to your security dashboard</Text>
      
      <TouchableOpacity 
        style={styles.button}
        onPress={() => navigation.navigate(APP_ROUTES.HEALTH_OVERVIEW)}
      >
        <Text style={styles.buttonText}>Go to Health Overview</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  subtitle: {
    fontSize: 18,
    color: '#666',
    marginBottom: 40,
  },
  button: {
    backgroundColor: '#4a90e2',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 8,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  }
});

export default HomeScreen;
EOL

cat > src/screens/OverviewScreen.tsx << 'EOL'
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

const OverviewScreen = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Health Overview</Text>
      <Text style={styles.subtitle}>Your health data summary</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
  },
});

export default OverviewScreen;
EOL

cat > src/screens/CalendarScreen.tsx << 'EOL'
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

const CalendarScreen = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Health Calendar</Text>
      <Text style={styles.subtitle}>Your health schedule and appointments</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
  },
});

export default CalendarScreen;
EOL

# Create API service
cat > src/services/api.ts << 'EOL'
import axios from 'axios';
import { API_ROUTES, HealthCheckStatus } from '@secure-guardians/shared';

// Define API base URL - update this with your actual API URL
const API_URL = 'http://localhost:3000';

// Create an axios instance
const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Health check API service
export const checkApiHealth = async (): Promise<HealthStatus> => {
  const response = await api.get(API_ROUTES.HEALTH);
  return response.data;
};

export default api;
EOL

# Go back to the root directory
cd ../../

# Add README
cat > README.md << 'EOL'
# SG_MOBILE Monorepo

A monorepo containing a Node.js Express API with class-based architecture and dependency injection, and a React Native app (without Expo) for Secure Guardians.

## Project Structure

```
SG_MOBILE/
├── packages/
│   ├── shared/       # Shared code, types, and utilities
│   ├── api/          # Node.js Express API with DI
│   │   ├── controllers/ # Request handlers (classes with DI)
│   │   ├── services/    # Business logic (classes with DI)
│   │   └── ioc/         # Dependency injection setup
│   └── app/          # React Native mobile app (without Expo)
├── package.json      # Root package.json for workspaces
└── tsconfig.json     # Base TypeScript configuration
```

## Dependency Injection

The API uses InversifyJS for dependency injection and inversify-express-utils for controller decorators. This provides:

- Clear separation of concerns
- Easier unit testing
- Cleaner, more maintainable code
- Type-safe dependency injection

## Getting Started

### Prerequisites

- Node.js (v18 or later)
- npm (v7 or later with workspaces support)
- Android Studio (for Android development)
- Xcode (for iOS development)

### Installation

1. Clone the repository
2. Install dependencies:
   ```
   npm install
   ```

### Development

#### Building shared package:
```
npm run --workspace=@secure-guardians/shared build
```

#### Running the API:
```
npm run dev:api
```

#### Running the mobile app:

For Android:
```
npm run --workspace=@secure-guardians/app android
```

For iOS:
```
npm run --workspace=@secure-guardians/app ios
```

### API Documentation

Swagger documentation is available at http://localhost:3000/api-docs when the API is running.

## Features

- Health check endpoint with class-based design and dependency injection
- Basic tab navigation with Overview and Calendar tabs
- Shared types and constants between API and app
EOL

# After the React Native app is set up, you would typically need to initialize the native projects
echo "SG_MOBILE monorepo setup completed!"
echo ""
echo "IMPORTANT: To complete React Native setup, you need to run:"
echo "cd packages/app && npx react-native init SecureGuardians --template react-native-template-typescript"
echo ""
echo "Then copy the ios/ and android/ folders from the initialized project to the app directory."