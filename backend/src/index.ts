import Fastify from 'fastify';
import cors from '@fastify/cors';

const fastify = Fastify({
  logger: true
});

async function start() {
  try {
    // Register CORS
    await fastify.register(cors, {
      origin: true
    });

    // Routes
    fastify.get('/', async () => {
      return { 
        message: 'Main Platform API',
        version: '1.0.0',
        timestamp: new Date().toISOString()
      };
    });

    fastify.get('/health', async () => {
      return { 
        status: 'ok',
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
      };
    });

    fastify.get('/test', async () => {
      return { 
        message: 'API Test Endpoint',
        environment: process.env.NODE_ENV,
        timestamp: new Date().toISOString()
      };
    });

    // Start server
    const port = parseInt(process.env.PORT || '3000');
    await fastify.listen({ port, host: '0.0.0.0' });
    
    console.log(`Server running on port ${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}

start();
