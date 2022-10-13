# CloudResumeChallenge

The tasks in the Cloud Resume challenge are as follows:

1. Certification - Your resume needs to have the AWS Cloud Practitioner certification on it. This is an introductory certification that orients you on the industry-leading AWS cloud – if you have a more advanced AWS cert, that’s fine but not expected.

2. HTML - Your resume needs to be written in HTML. Not a Word doc, not a PDF.

3. CSS - Your resume needs to be styled with CSS. No worries if you’re not a designer – neither am I. It doesn’t have to be fancy. But we need to see something other than raw HTML when we open the webpage.

~~4. Static Website - Your HTML resume should be deployed online as an Amazon S3 static website. Services like Netlify and GitHub Pages are great and I would normally recommend them for personal static site deployments, but they make things a little too abstract for our purposes here. Use S3.~~

~~5. HTTPS - The S3 website URL should use HTTPS for security. You will need to use Amazon CloudFront to help with this.~~

~~6. DNS - Point a custom DNS domain name to the CloudFront distribution, so your resume can be accessed at something like my-c00l-resume-website.com. You can use Amazon Route 53 or any other DNS provider for this. ~~

~~7. Javascript - Your resume webpage should include a visitor counter that displays how many people have accessed the site. You will need to write a bit of Javascript to make this happen.~~

~~8. Database - The visitor counter will need to retrieve and update its count in a database somewhere. I suggest you use Amazon’s DynamoDB for this.~~

~~9. API - Do not communicate directly with DynamoDB from your Javascript code. Instead, you will need to create an API that accepts requests from your web app and communicates with the database. I suggest using AWS’s API Gateway and Lambda services for this.~~

~~10. Python - You will need to write a bit of code in the Lambda function; you could use more Javascript, but it would be better for our purposes to explore Python – a common language used in back-end programs and scripts – and its boto3 library for AWS.~~

~~11. Tests - You should also include some tests for your Python code. I am going to use Cypress, a Javascript web-based end to end testing tool.~~

12. Infrastructure as Code - You should not be configuring your API resources – the DynamoDB table, the API Gateway, the Lambda function – manually, by clicking around in the AWS console. Instead, these resources should be defined via Terraform.

13. Source Control - You do not want to be updating either your back-end API or your front-end website by making calls from your laptop, though. You want them to update automatically whenever you make a change to the code. 

14 - CI/CD (Back End) - Set up GitHub Actions such that when you push an update to your Serverless Application Model template or Python code, your Python tests get run. If the tests pass, the SAM application should get packaged and deployed to AWS.

15. CI/CD (Front End) - Create a second GitHub repository for your website code. Create GitHub Actions such that when you push new website code, the S3 bucket automatically gets updated. (You may need to invalidate your CloudFront cache in the code as well.) 

16. Blog post - Finally, in the text of your resume, you should link a short blog post describing some things you learned while working on this project.

fdafdsafdsfdasf
