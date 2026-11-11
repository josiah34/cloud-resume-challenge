# Cloud Resume Challenge

My personal resume and portfolio website, built as part of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/). I chose AWS for this project, with the main focus on the infrastructure behind the site: hosting, DNS, HTTPS, a serverless visitor counter, infrastructure as code, and automated deployment.

The frontend uses vanilla HTML, CSS, and JavaScript to showcase my experience, skills, and projects.

**[View the live site →](https://resume.josiah-galloway.ca/)**

## Architecture

![AWS architecture diagram for the Cloud Resume project](https://github.com/josiah34/cloud-resume-challenge/assets/25124463/a6483fbe-a483-4561-9a9f-469672143cb0)

### Website delivery

Route 53 manages DNS for `josiah-galloway.ca`, with the resume available at `resume.josiah-galloway.ca`. CloudFront serves the static files from a private S3 bucket over HTTPS, using a certificate from AWS Certificate Manager. The bucket policy allows CloudFront to access the site assets.

### Visitor counter

The browser calls a Lambda function URL, with Lambda and DynamoDB providing the visitor-counter backend. The frontend validates the returned count before displaying it. If the request fails or times out, the page displays a dash so the rest of the site remains usable.

### Services and tools

| Service or tool | Role in the project |
| --- | --- |
| Amazon S3 | Stores the static website files |
| Amazon CloudFront | Delivers the site and provides the HTTPS entry point |
| Amazon Route 53 | Manages DNS for the custom domain |
| AWS Certificate Manager | Provides the TLS certificate |
| AWS Lambda | Handles visitor-counter requests |
| Amazon DynamoDB | Stores the visitor count |
| Terraform | Defines and manages infrastructure |
| Terraformer | Imports existing AWS resources into Terraform configuration |
| GitHub Actions | Deploys site files and invalidates the CloudFront cache |
| HTML, CSS, and JavaScript | Provide the portfolio layout and browser interactions |

## Implementation journey

### 1. Build the frontend

I created the portfolio using HTML, CSS, and JavaScript. The current site includes a responsive layout, mobile navigation, experience and skills sections, project cards, and a visitor counter.

### 2. Set up static hosting

I started with a Terraform configuration that created the S3 bucket and uploaded a placeholder page. This gave me a simple way to confirm that the hosting infrastructure worked before uploading the full portfolio.

### 3. Configure the domain and HTTPS

I created a Route 53 hosted zone for `josiah-galloway.ca` and updated the domain's nameservers to use it. I then obtained an ACM certificate, created a CloudFront distribution, and configured `resume.josiah-galloway.ca` as an alternate domain name.

With the S3 bucket policy allowing access from CloudFront, I verified the placeholder page through the custom domain and then uploaded the actual portfolio using Terraform.

### 4. Automate frontend deployment

I added a GitHub Actions workflow to sync the website files to S3 on pushes to `main`. The workflow also invalidates the CloudFront cache when site files change, allowing updated content to be served without waiting for the cached version to expire.

### 5. Capture infrastructure with Terraformer

I used Terraformer to import existing AWS resources and generate Terraform configuration. This included the hosting services as well as Lambda and DynamoDB resources for the visitor counter.

## Infrastructure as code

Terraform and Terraformer were part of the original infrastructure workflow. The commands below preserve that implementation history; the Terraform configuration and visitor-counter backend source are not present in this checkout.

### Original Terraformer setup

I installed Terraformer using Chocolatey:

```sh
choco install terraformer
```

The original `provider.tf` used the AWS provider and my local `default` AWS profile:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.25"
    }
  }
}

provider "aws" {
  profile = "default"
}
```

The provider constraint above records the version used for the original setup.

I initialized the working directory with:

```sh
terraform init
```

### Import existing resources

My original import command for Route 53, security groups, IAM, CloudFront, and ACM was:

```sh
terraformer import aws --resources=route53,sg,iam,cloudfront,acm
```

This command included both global and regional services. Regional resources such as security groups and ACM certificates need the appropriate region selected when reproducing the import.

I imported Lambda and DynamoDB from `us-east-1`:

```sh
terraformer import aws --resources=lambda,dynamodb --regions=us-east-1
```

The site's S3 bucket was created in `us-east-2`, so I imported it separately:

```sh
terraformer import aws --resources=s3 --regions=us-east-2
```

The generated directory structure from the original import:

![Terraformer-generated infrastructure directory structure](https://github.com/josiah34/cloud-resume-challenge/assets/25124463/c036c5c1-b168-4890-a733-f048b52c7662)

## CI/CD pipeline

The deployment workflow lives in [`.github/workflows/main.yml`](.github/workflows/main.yml) and runs on pushes to `main`.

1. Check out the repository.
2. Configure AWS credentials from GitHub Actions secrets, using `us-east-2`.
3. Detect changed files between the previous and current commit.
4. Sync `site/` to `s3://jg-cloud-resume-bucket` when changes are detected.
5. Invalidate the CloudFront cache when the captured change output includes `site/`.

The workflow requires these repository secrets:

| Secret | Purpose |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Access key for the deployment identity |
| `AWS_SECRET_ACCESS_KEY` | Secret key for the deployment identity |
| `DISTRIBUTION_ID` | CloudFront distribution to invalidate |

The S3 sync uses `--delete`, so removing a file from `site/` also removes it from the destination bucket on deployment. The current change check covers the whole repository, so documentation-only changes can also trigger an S3 sync.

### Current change-detection limitation

The workflow passes the changed-file list through a single-line `set-output` command. When a push changes multiple files, only the first filename is captured in the step output. For example, a push changing both `README.md` and `site/index.html` captures `README.md`, uploads the site, and skips CloudFront invalidation because the output does not contain `site/`.

An index-only commit captures `site/index.html` and triggers the invalidation step. A successful workflow run with invalidation skipped can leave CloudFront serving the previous cached version even after the updated files reach S3.

## Repository structure

```text
.github/
  workflows/
    main.yml               # Website deployment to S3 and CloudFront invalidation
site/
  index.html               # Portfolio content and page structure
  style.css                # Main styles
  mediaqueries.css         # Responsive styles
  script.js                # Mobile navigation and footer year
  counter.js               # Visitor-counter request and display
  assets/                  # Portfolio images and static assets
README.md                  # Project overview and implementation notes
```

The frontend has no build step or package dependencies. Content changes are made in `site/index.html`, styling lives in the CSS files, and browser behavior lives in the JavaScript files.

## Next steps

- Add automated tests for the website and visitor-counter backend.
- Add a custom error page.
- Continue improving the portfolio content, accessibility, and responsive design.

## References

- [Cloud Resume Challenge — AWS](https://cloudresumechallenge.dev/docs/the-challenge/aws/)
- [Terraformer documentation](https://github.com/GoogleCloudPlatform/terraformer)
- [Original hosting tutorial](https://aws.plainenglish.io/host-resume-website-on-aws-using-amazon-s3-cloudfront-route53-9c7f9afad6f3)
- [Video walkthrough used during the project](https://www.youtube.com/watch?v=e7vZe7qZFmE&list=PLEk97Q5Nj5oesA1WNk7DzaUpZUnCsQFVQ&ab_channel=OpenUpTheCloud)
