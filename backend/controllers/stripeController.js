const Stripe = require('stripe');
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

exports.createPaymentIntent = async (req, res) => {
  try {
    console.log("Request received:", {
      body: req.body,
      headers: req.headers
    });

    const { amount, currency = 'lkr' } = req.body;
    
    // Validate amount
    if (!amount || isNaN(amount)) {
      console.log("Invalid amount received:", amount);
      return res.status(400).json({ 
        error: 'Invalid amount',
        received: amount
      });
    }

    const amountInCents = Math.round(amount * 100);
    console.log("Creating payment intent for:", {
      amount: amountInCents,
      currency
    });

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInCents,
      currency: currency.toLowerCase(),
      automatic_payment_methods: { enabled: true },
      metadata: {
        integration_check: 'accept_a_payment',
        app_name: 'Furniture App'
      }
    });

    console.log("PaymentIntent created successfully:", {
      id: paymentIntent.id,
      amount: paymentIntent.amount,
      status: paymentIntent.status,
      client_secret: paymentIntent.client_secret ? 'exists' : 'missing'
    });

    res.json({
      success: true,
      clientSecret: paymentIntent.client_secret,
      ephemeralKey: paymentIntent.ephemeralKey,
      customer: paymentIntent.customer,
      id: paymentIntent.id,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency
    });
    
  } catch (error) {
    console.error('Stripe error:', {
      message: error.message,
      type: error.type,
      code: error.code,
      statusCode: error.statusCode,
      stack: error.stack
    });
    
    res.status(500).json({ 
      success: false,
      error: {
        message: error.message,
        type: error.type || 'StripeError',
        code: error.code
      }
    });
  }
};