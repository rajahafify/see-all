# See All

See All is a web application that allows users to analyze and transcribe live video streams using AI services. It enables streamers to broadcast using OBS and interact with an AI that provides real-time feedback and advice about their stream, such as gaming tips for specific video games.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Docker and Docker Compose are required to run the project. Docker is used for containerization, ensuring consistent environments across different setups, and Docker Compose simplifies the management of multi-container applications.

### Installing

1. Clone the repository:
   ```bash
   git clone https://github.com/rajahafify/see-all.git
   ```

## Running the Project

1. Start the project:
   ```bash
   docker-compose up --build
   ```
   After running this command, the application should be available at `http://localhost:3000`.

## Design Document

### Architecture Overview

See All is built using a microservices architecture with the following main components:

1. Web Application (Rails)
2. RTMP Server (Nginx-RTMP)
3. Stream Processing Service
4. AI Interaction Service
5. WebSocket Server (Action Cable)
6. SQlite
7. Job Queue (Sidekiq + Redis)

### Key Components

1. **Web Application**
   - Handles user authentication and stream management
   - Provides UI for streamers to interact with AI
   - Manages WebSocket connections for real-time updates

2. **RTMP Server**
   - Receives video streams from OBS
   - Forwards streams to the Stream Processing Service

3. **Stream Processing Service**
   - Generates frames from incoming video streams
   - Analyzes frames for game detection and other relevant information

4. **AI Interaction Service**
   - Processes stream data and user queries
   - Generates relevant responses and advice using AI models
   - Integrates with external AI APIs (e.g., OpenAI GPT)

5. **WebSocket Server**
   - Facilitates real-time communication between the web app and AI service

6. **Database**
   - Stores user information, stream metadata, and interaction history

7. **Job Queue**
   - Manages background jobs for stream processing and AI interactions

### Planned Features

1. AI-powered game advice and interaction
2. Real-time chat between streamer and AI


1. AI-powered game advice and interaction
2. Real-time chat between streamer and AI

### Data Flow

1. Streamer starts a broadcast using OBS
2. RTMP server receives the stream and notifies the web application
3. Stream Processing Service begins generating and analyzing frames
4. AI Interaction Service processes stream data and awaits user queries
5. Streamer interacts with AI through the web interface
6. WebSocket server facilitates real-time communication between components
7. AI responses are sent back to the streamer in real-time

### Technology Stack

- Backend: Ruby on Rails
- Frontend: HTML, CSS, JavaScript (with Stimulus.js)
- Streaming: Nginx-RTMP
- AI Integration: Anthropic API
- Database: SQlite
- Job Queue: Sidekiq
- Caching: Redis
- Containerization: Docker

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes.
4. Push your changes to your fork.
5. Submit a pull request.

For more detailed guidelines, please refer to [CONTRIBUTING.md](CONTRIBUTING.md).
