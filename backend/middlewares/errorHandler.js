const errorHandler = (err, req, res, next) => {
    console.error(err.stack);
    
    // Handle specific error types
    if (err.message.includes('not found')) {
      return res.status(404).json({ error: err.message });
    }
    
    if (err.message.includes('required') || err.message.includes('missing')) {
      return res.status(400).json({ error: err.message });
    }
    
    if (err.message.includes('credentials')) {
      return res.status(401).json({ error: err.message });
    }
    
    // Default error response
    res.status(500).json({ 
      error: 'Internal server error',
      message: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  };
  
  module.exports = errorHandler;