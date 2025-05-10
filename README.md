# AWS Task 4: Set Up a Static Website Using Amazon S3 to Display Your Portfolio

## Objective

Host a static personal portfolio website using Amazon S3 with public access.

---

## Task Steps

### 1. Create an S3 Bucket

- Open the AWS S3 Console.
- Click **Create bucket**.
- Choose a **globally unique name** (e.g., `my-portfolio-site`).
- Select a region close to your audience.
- Leave other settings as default and click **Create**.

### 2. Enable Static Website Hosting

- Go to the **Properties** tab of the bucket.
- Scroll to **Static website hosting** and click **Edit**.
- Enable hosting and choose **Use this bucket to host a website**.
- Set:
  - **Index document**: `index.html`
  - **Error document**: `error.html` (optional)
- Click **Save changes**.

### 3. Upload Your Portfolio Files

- In the bucket, click **Upload** and add:
  - `index.html`
  - Any supporting files (e.g., `style.css`, images, etc.)
- Make files **public** using:
  - Object ACLs (select "Grant public-read access"), or
  - A **Bucket Policy** (recommended).

### 4. Set Bucket Permissions for Public Access

- In the **Permissions** tab:
  - Under **Block public access**, click **Edit**.
  - Uncheck “Block all public access” and confirm changes.
- Apply this **bucket policy** to allow public read access:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
