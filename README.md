# AI News & Tools Aggregator

A web application that aggregates and categorizes information about agentic AI developments - including new tools, applications, trends, courses, and business use cases. Built with a clean Stripe-inspired UI and designed specifically to make AI developments accessible to non-technical users.

## Core Architecture

This application is built around four primary concerns:

1. **Data Collection**: Web scrapers that extract information from various sources
2. **Data Processing**: Categorization, deduplication, and normalization of scraped content
3. **Data Storage**: Persistence layer (currently file-based, with options for database integration)
4. **Presentation**: React-based UI with filtering, search, and categorization

The system uses a hybrid approach to data collection:

- **GitHub Actions** for scheduled scraping (decoupling resource-intensive scraping from the web server)
- **Express API** for serving categorized content
- **React Frontend** for presentation with filtering and search capabilities

```
GitHub Actions Workflow    Web Application
┌─────────────────────┐   ┌───────────────────────────┐
│                     │   │                           │
│  Scheduled Scraping ├───┤  Content API    React UI  │
│                     │   │                           │
└─────────────────────┘   └───────────────────────────┘
         │                            ▲
         │                            │
         ▼                            │
┌─────────────────────┐               │
│                     │               │
│   Data Repository   ├───────────────┘
│                     │
└─────────────────────┘
```

## Getting Started

### Prerequisites

- Node.js 18+ and npm/yarn
- Git
- GitHub account (for repository hosting and Actions)

### Local Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ai-aggregator.git
   cd ai-aggregator
   ```

2. Install dependencies:
   ```bash
   # Root dependencies
   npm install
   
   # Client dependencies
   cd client && npm install && cd ..
   ```

3. Start the development servers:
   ```bash
   npm run dev
   ```

This runs both the backend (port 3001) and frontend (port 3000) with hot reloading enabled.

## Configuration

### Scraper Configuration

Scrapers are defined in `server/scrapers/` as separate modules. Each scraper has:

- Source information (name, URL)
- DOM selectors for extracting content
- Processing logic for categorization and normalization

To add a new scraper:

1. Create a new file in `server/scrapers/`
2. Define the selectors and processing logic
3. Export the scraper configuration
4. Import and register it in `server/server.js`

Example scraper configuration:

```javascript
module.exports = {
  name: 'AI News Blog',
  url: 'https://example.com/ai-news',
  selectors: {
    articles: 'article.post',
    title: 'h2.entry-title',
    link: 'h2.entry-title a',
    description: '.entry-content p:first-of-type',
    date: '.entry-date'
  },
  process: function($, article) {
    // Processing logic
    // Returns structured data object
  }
};
```

### Environment Variables

Create a `.env` file in the root directory:

```
PORT=3001              # Backend server port
NODE_ENV=development   # Environment (development/production)
```

For the client (in production):

```
REACT_APP_API_URL=https://your-backend-url.com  # Production API endpoint
```

## Deployment

The application supports multiple deployment approaches, each with different tradeoffs:

### Option 1: Separate Frontend/Backend (Recommended)

This approach gives you the most flexibility and scalability:

1. **Backend on Render/Railway**:
   - Connect to your GitHub repository
   - Build Command: `npm install`
   - Start Command: `npm run start:server`
   - Environment Variables: 
     - `PORT`: 10000 (platform default)
     - `NODE_ENV`: production
   - Enable persistent disk storage (Render) or add a volume (Railway)

2. **Frontend on Vercel/Netlify**:
   - Connect to your GitHub repository
   - Root Directory: `client`
   - Build Command: `npm run build`
   - Output Directory: `build`
   - Environment Variables:
     - `REACT_APP_API_URL`: Your backend URL

3. **GitHub Actions for Scraping**:
   - Already configured in `.github/workflows/scheduled-scrape.yml`
   - Runs twice daily and commits data back to the repository
   - No additional setup required

This architecture elegantly separates concerns:
- Content serving (low CPU, high availability requirements)
- Web scraping (high CPU, can tolerate occasional failures)
- Frontend hosting (static assets, optimized for global delivery)

### Option 2: Single Platform Deployment

For simpler projects, you can deploy everything to a single platform:

1. **Render/Railway Full Stack**:
   - Build Command: `npm install && cd client && npm run build`
   - Start Command: `npm start`
   - Environment Variables as above
   - Enable persistent storage

2. **GitHub Actions** for scraping (as above)

### Option 3: Docker Deployment

For complete control, use the included Docker configuration:

```bash
# Build and run with Docker Compose
docker-compose up -d
```

This creates a containerized application with a persistent volume for data storage.

## Maintenance Guidelines

### The Reality of Web Scraping

Web scraping is inherently brittle - websites change their structure frequently. Expect regular maintenance needs:

1. **Monitor Scraper Health**:
   - Check GitHub Actions logs for failures
   - Set up notifications for scraper failures
   - Periodically verify data freshness

2. **Updating Broken Scrapers**:
   - Identify the failing source
   - Inspect the current website structure
   - Update selectors in the corresponding scraper configuration
   - Test locally before committing

3. **Scaling Considerations**:
   - If your dataset grows beyond a few MB, consider migrating to a proper database
   - For high-traffic deployments, implement caching in the API layer
   - Consider implementing rate limiting for external scrapers

### Troubleshooting

Common issues and solutions:

#### Scraper Failures

- **Timeout errors**: Increase the timeout in the scraper configuration
- **Invalid selector errors**: The website structure has changed; update selectors
- **Rate limiting**: Implement delays between requests or IP rotation

#### Deployment Issues

- **Data persistence**: Ensure persistent storage is properly configured
- **CORS errors**: Verify API URL configuration and CORS headers
- **Build failures**: Check for dependency conflicts or Node.js version mismatches

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT

## Acknowledgments

This project uses several open-source libraries:
- React for the frontend UI
- Express for the API server
- Cheerio for web scraping
- Node-cron for scheduling

## About the Project

This aggregator was created to democratize access to AI developments, making the rapidly evolving landscape of agentic AI accessible to non-technical users. The focus is on practical applications, educational resources, and emerging trends.
