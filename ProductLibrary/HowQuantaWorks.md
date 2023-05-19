Quanta gives you a simple yet totally new way of seeing and thinking about your money.

In order to accomplish this without you having to enter any data the Quanta system securely imports your transaction history directly from your bank(s) and credit card(s) then performs a proprietary analysis that outputs your unique financial summary.

That’s the short version, a detailed explanation of how Quanta works follows.

## BANK CONNECTION

We use a company called Plaid to access your transaction stream. 

Plaid is based in San Francisco and they provide financial data services to many of the largest financial companies in the world (eg. American Express & Venmo/PayPal). Tens of millions of people around the world have connected their accounts to apps they love using Plaid. Check them out at https://plaid.com/

Plaid regularly undergoes both internal and external network penetration tests, third-party code reviews, and further maintains the effectiveness of their security program using independent auditors.

So, with Quanta this is what happens when you go through the steps to link your account(s):

1. The app will show you a list of banks / credit card companies and you choose yours.

2. Your bank will ask you to sign-in using your username and password. Possibly you’ll need to do an additional verification via text or email. This process is completely isolated from Quanta and happens between you and your bank. **QUANTA NEVER SEES YOUR BANK CREDENTIALS**

3. Once signed-in successfully, your bank tells Quanta “Ok, good to go” and the system kicks off the import of your transaction history.

## TRANSACTION IMPORT

Most banks and credit card companies provide 6 to 24 months of transaction history. Quanta imports data back as far as it is available via your financial institution.

The transactions are imported from your bank to Quanta over a secure connection entirely in the cloud. The transactions are never sent in their entirety to your phone.

When the system gets a transaction from your bank it has the following information, for example:

```
{
	"account_id": "KjqYzgz5ZxF1akPV33kLuxdm5VNaNXIQQJx44",
	"amount": 128.64,
	"category": [
		"Shops"
	],
	"date": "2019-01-06",
	"institution_id": "ins_10",
	"iso_currency_code": "USD",
	"location": {
		"address": "PO BOX 81226",
		"city": "Seattle",
		"state": "WA"
	},
	"name": "Amazon",
	"payment_meta": {
		"reference_number": "320190070329715027"
	},
	"pending": false,
	"transaction_id": "00vXpjp59gUb3V1xDDV7cgoBA17yyzFrKgZPg",
	"transaction_type": "place"
}
```

And sometimes a transaction comes with a field called “account_owner”. When a transaction shows up with this field, Quanta tosses it out immediately, before ever storing it.

Additionally, Quanta tosses out the “location” data. We’ve designed the system to do this to protect your privacy. You can read more about our philosophy and approach to privacy and security elsewhere in the app but the key point to know is that we store as little data as possible and dissociate personally identifiable information from financial data as much as possible.

Quanta only has the ‘window’ into your finances that you offer through the bank connections you make. Quanta does not have visibility into any retirement account withholdings (eg 401k) from your paycheck or employee stock programs or other such ‘savings’ activities.

## QUANTA FINANCIAL DATA PROCESSING

Once all your transactions are imported, often they number in the thousands, Quanta’s financial intelligence uses algorithms to determine:

* How much money you make
* What recurring spending ‘streams’ you have
* Where your money goes across categories
* How much your credit cards are really costing
* What your savings rate is
* Much more...

## EVERY MORNING, VERY EARLY

Banks and other financial institutions settle up their books each night and your new transactions for the day are made available to Quanta. The new transactions are securely imported into the Quanta system and your financial profile is updated by the algorithms mentioned in the previous section.

This activity culminates in the sending of a single push notification to you that includes just the most essential facts about your financial activity of the previous day -- was it a surplus or deficit? How much so? How many transactions and how much in / out. And finally, where do you stand on the month? Are you headed for a monthly profit or loss?

Swipe this notif to dive into the app and the details.

## WEEKLY & MONTHLY

In addition to the daily notification, Quanta will send you weekly and monthly recaps. These three touch points should enable you to get really familiar with where your money is going, and if you’re inclined to make any changes, Quanta’s summaries are a great place to get started in identifying the high-leverage opportunities to sharpen up your financial life.
