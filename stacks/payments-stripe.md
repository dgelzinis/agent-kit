# Problem pack: payments with Stripe

**Standards:** Stripe's own docs are the standard (docs.stripe.com: Checkout, Billing, Webhooks, "Go-live checklist"); PCI DSS scope is kept minimal by never touching card data yourself.

## Never
- Never handle or store card numbers: use Stripe Checkout, Payment Element or the Customer Portal.
- Never trust a price, plan, amount or "paid" flag from the browser. Prices are Stripe Price ids chosen on the server.
- Never put the secret key or webhook secret in frontend code, logs or the repo. Test and live keys are separate; code picks by environment.

## Webhooks are the source of truth
- Access is granted or removed from webhook events (`checkout.session.completed`, `customer.subscription.updated`/`deleted`, `invoice.paid`, `invoice.payment_failed`), not from the success redirect, which a user can open or skip.
- Verify the signature on the raw request body before anything else.
- Handle each event idempotently (record processed event ids): Stripe retries and may deliver out of order. Respond 2xx fast; do slow work after.
- On doubt, fetch the current object from Stripe rather than trusting event order.

## State
- Store the Stripe customer id and subscription id against the account; derive the plan and entitlements from the subscription's status and price.
- Handle every status: trialing, active, past_due, canceled, incomplete, paused. Decide what the user keeps in each.
- Use idempotency keys on API calls that create charges, subscriptions or refunds.

## Product behaviour
- Show price, billing period, tax and renewal terms before payment; send receipts; make cancelling as easy as subscribing.
- Proration, upgrades and downgrades follow Stripe's behaviour; do not compute amounts yourself.
- Test with Stripe test clocks and test cards, including failed payments and renewals, before going live. Changing live prices or products is the owner's action.
