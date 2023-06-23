# Cloud Resume Project 

This is my attempt at the cloud resume project. This repo will contain all my site code as well as my Terraform scripts. The main focus of this project is the cloud infrastructure. The challenge can be done in AWS, GCP or Azure, but I chose AWS. 

[Link to Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/)

[Link to my cloud resume site](https://resume.josiah-galloway.ca/)

## Done 

- Code a simple portfolio website using vanilla javascript, html and css.
- I created an initial terraform script that sets up my s3 bucket for my static site. It also uploads a dummy template to confirm its working later on.
- Configured my custom domain ``josiah-galloway.ca`` in Route53 and created my hosted zone.
- Set my DNS servers from my hosted zone in my host nameservers to allow Route53 to perform routing.
- Obtained SSL Certificate from AWS Certificate Manager so that I can have https.
- Created CloudFront Distribution with my SSL certificate.
- Set alternate domain in CloudFront as ``resume.josiah-galloway.ca``
- Set bucket policy to allow access from my CloudFront distribution to my private S3 bucket
- At this point I was able to view my resume site with the dummy template I uploaded earlier.
- Used terraform script to upload my actual portfolio site.
- Setup a Github Actions CICD pipeline to push my site code from this repository to my s3 bucket. This CICD uploads changes in site folder to s3 bucket if detected and invalidates CloudFront Cache. Invalidation is required or the old site will be served from the cache for an additional 24 hours. 


## To Do

- Use Terraformer to generate Terraform code so that I can destroy and redeploy my infrastructure as neeeded
- Add Tests
- Write AWS Certified Cloud Practioner Exam
- Finish editing information and general improvments on website code.
- Add an error page 




## Architecture 


![Untitled Diagram drawio (1)](https://github.com/josiah34/cloud-resume-challenge/assets/25124463/a6483fbe-a483-4561-9a9f-469672143cb0)





**Services and Tools**
- S3 Bucket (Static Website)
- CloudFront
- Certificate Manager
- Route 53
- Terraform (Infrastructure as Code)
- Lambda
- DynamoDB
- Github Actions (CICD)


<details>

<summary>The Challenge</summary>

1. Certification
Your resume needs to have the AWS Cloud Practitioner certification on it. This is an introductory certification that orients you on the industry-leading AWS cloud – if you have a more advanced AWS cert, that’s fine but not expected. You can sit this exam online for $100 USD. A Cloud Guru offers exam prep resources.

2. HTML
Your resume needs to be written in HTML. Not a Word doc, not a PDF. Here is an example of what I mean.

3. CSS
Your resume needs to be styled with CSS. No worries if you’re not a designer – neither am I. It doesn’t have to be fancy. But we need to see something other than raw HTML when we open the webpage.

4. Static Website
Your HTML resume should be deployed online as an Amazon S3 static website. Services like Netlify and GitHub Pages are great and I would normally recommend them for personal static site deployments, but they make things a little too abstract for our purposes here. Use S3.

5. HTTPS
The S3 website URL should use HTTPS for security. You will need to use Amazon CloudFront to help with this.

6. DNS
Point a custom DNS domain name to the CloudFront distribution, so your resume can be accessed at something like my-c00l-resume-website.com. You can use Amazon Route 53 or any other DNS provider for this. A domain name usually costs about ten bucks to register.

7. Javascript
Your resume webpage should include a visitor counter that displays how many people have accessed the site. You will need to write a bit of Javascript to make this happen. Here is a helpful tutorial to get you started in the right direction.

8. Database
The visitor counter will need to retrieve and update its count in a database somewhere. I suggest you use Amazon’s DynamoDB for this. (Use on-demand pricing for the database and you’ll pay essentially nothing, unless you store or retrieve much more data than this project requires.) Here is a great free course on DynamoDB.

9. API
Do not communicate directly with DynamoDB from your Javascript code. Instead, you will need to create an API that accepts requests from your web app and communicates with the database. I suggest using AWS’s API Gateway and Lambda services for this. They will be free or close to free for what we are doing.

10. Python
You will need to write a bit of code in the Lambda function; you could use more Javascript, but it would be better for our purposes to explore Python – a common language used in back-end programs and scripts – and its boto3 library for AWS. Here is a good, free Python tutorial.

11. Tests
You should also include some tests for your Python code. Here are some resources on writing good Python tests.

12. Infrastructure as Code
You should not be configuring your API resources – the DynamoDB table, the API Gateway, the Lambda function – manually, by clicking around in the AWS console. Instead, define them in an AWS Serverless Application Model (SAM) template and deploy them using the AWS SAM CLI. This is called “infrastructure as code” or IaC. It saves you time in the long run.

Note: A more broadly applicable and commonly-used IaC tool in the industry is Terraform. It’s a little less straightforward to use than SAM for an AWS serverless API, but many people prefer to use it for their project anyway. If you want to use Terraform instead of SAM, follow this guide.

13. Source Control
You do not want to be updating either your back-end API or your front-end website by making calls from your laptop, though. You want them to update automatically whenever you make a change to the code. (This is called continuous integration and deployment, or CI/CD.) Create a GitHub repository for your backend code.

14. CI/CD (Back end)
Set up GitHub Actions such that when you push an update to your Serverless Application Model template or Python code, your Python tests get run. If the tests pass, the SAM application should get packaged and deployed to AWS.

15. CI/CD (Front end)
Create a second GitHub repository for your website code. Create GitHub Actions such that when you push new website code, the S3 bucket automatically gets updated. (You may need to invalidate your CloudFront cache in the code as well.) Important note: DO NOT commit AWS credentials to source control! Bad hats will find them and use them against you.

</details>


