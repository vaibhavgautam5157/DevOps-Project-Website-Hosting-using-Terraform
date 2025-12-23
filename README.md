# DevOps Project Report: Automated Static Website Hosting Using Terraform on AWS

**Author:** Vaibhav Gautam
**Date:** December 23, 2025

---

### *WEBSITE*
<img width="1919" height="1018" alt="6" src="https://github.com/user-attachments/assets/782e86ed-8789-4731-98c7-bfe25b5d1bca" />

---

### **Table of Contents**
1. [Project Overview](1-project-overview)
2. [Creating Terraform Configuration Files](terraform-config-files)
   * [provider.tf](provider.tf)
   * [bucket.tf](bucket.tf)
   * [variable.tf](variable.tf)
3. [Website Prerequisite Files](website-prerequisite-files)
   * [index.html](index.html)
   * [error.html](error.html)
4. [Terraform Deployment](terraform-deployment) 
5. [Working Diagram](working-diagram)  
6. [Conclusion](conclusion)

---

### 📌 **1. Project Overview**

This project automates the deployment of a **static website on AWS** using **Terraform (Infrastructure as Code)**.  
The website is hosted on an **Amazon S3 bucket** configured for static website hosting. Using Terraform ensures repeatable, version-controlled infrastructure provisioning eliminating manual AWS console steps.

Key services used:
- **Terraform** — Infrastructure as Code tool  
- **AWS S3** — Static website hosting via bucket configuration  
- **VS code** — creating required .tf files

---

### 🛠**2. Creating Terraform Configuration Files**

Ensure to have these three terraform files.

#### 1. **provider.tf**
Defines the cloud provider and authentication details.

```prvider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
```

#### 2. **bucket.tf (main.tf)**
Contains the core infrastructure resource definitions.

```bucket.tf
## Create an S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

## Set ownership controls to BucketOwnerPreferred
resource "aws_s3_bucket_ownership_controls" "mybucket" {
  bucket = aws_s3_bucket.mybucket.bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## Make the bucket publicly accessible
resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "mybucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mybucket,
    aws_s3_bucket_public_access_block.mybucket,
  ]

  bucket = aws_s3_bucket.mybucket.bucket
  acl    = "public-read"
}

## Upload website files to the S3 bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "inner-logo.png" 
  source = "inner-logo.png"
  acl    = "public-read"
  content_type = "image/png"
}

resource "aws_s3_object" "wallpaper" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "wallpaperflare.com_wallpaper (13).jpg"
  source = "wallpaperflare.com_wallpaper (13).jpg"
  acl    = "public-read"
  content_type = "image/jpg"
}

## Configure the S3 bucket for website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.mybucket ]
}
```

#### 3. **variable.tf**
Declares input variables used in the configuration.

```variable.tf
variable "bucketname" {
  default = "mywebsiteusingterraform123123"
}
```

---

### 🌐3. **Website Prerequisite Files**
#### 1. **index.html**
```index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> BBT Landing Page </title>
<style type="text/CSS">
    *{padding: 0; margin: 0; box-sizing: border-box;}
    header{
        width: 100%;
        height: 100vh;
        background:linear-gradient(rgba(2, 1, 8, 0.8),rgba(0, 0, 0, 0.2)), url('wallpaperflare.com_wallpaper (13).jpg');
        background-size: cover;
        font-family: sans-serif;
    }
    nav{
        width: 100%;
        height: 100px;
        color: white;
        display: flex;
        justify-content: space-around;
        align-items: center;
        box-sizing: border-box;

    }

    .logo{
        /* border: 2px solid red; */
        display: inline-block;
        position: absolute;
        /* margin-top: 2%; */
        left: 40px;
        top: 30px;
    }

    .logo img{
        width: 120px;
    }

    .bar a{
        text-decoration: none;
        color: white;
        padding: 10px 20px;
        font-family: Georgia, 'Times New Roman', Times, serif;
        font-size: 20px;
        position: relative;
    }  
    .bar a:before{
        content: ' ';
        position: absolute;
        top: 0;
        left: 0;
        width: 0%;
        height: 100%; 
        border-bottom: 2px solid rgb(94, 23, 23);
        transition:0.4s linear; 
    }
    
    .bar a:hover:before{
        width: 90%;
   
    }
    .menu{
        position: absolute;
        display: inline-block;
        box-sizing: border-box;
        right: 33px;
        top: 35px;
    }
    .menu a{
        text-decoration: none;
        color: white;
        padding: 8px 20px;
        font-size: 20px; 
        background: rgb(145, 12, 12);
        border-radius: 4px;
        transition: 0.4s;
        
    }

    .menu a:hover{  
        background: transparent;
        border: 1px solid rgb(105, 41, 41);
    }



    
   /* section span{
        color: white;
        max-widt
    }

    h1{
        color: white;
    }*/
    .h-txt{
        max-width: 650px;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%,-50%);
        text-align: center;
        color: white;
    }
    .h-txt span x{
        
        letter-spacing: 5px;
        font-size:  48px;
        color: rgb(184, 3, 3);
    }
    .h-txt span{
        letter-spacing: 5px;
        font-size:  2.8em;
  
    }
    .h-txt h1{
        font-size: 15px;
        font-family: Georgia, 'Times New Roman', Times, serif;
    }    
    .h-txt a{
          text-decoration: none;
          background: rgb(220, 19, 19);
          color: white;
          padding: 10px 20px;
          letter-spacing: 5px;
          transition: 0.4s;

    }
    .h-txt a:hover{  
        background: transparent;
        border: 1px solid rgb(105, 41, 41);
    }
 

</style>
</head>
<body>
<header>
    <nav>
        <div class="logo">
            <a href="https://www.bigboytoyz.com/">
                <img src="inner-logo.png"></a>
        </div>
        <div class="bar">

            <a href="#"> BUY </a>
            <a href="#"> SELL </a>
            <a href="#"> VINTAGE CAR </a>
            <a href="#"> STORIES </S></a>
            </div>
        <div class="menu">
            <a href="#"> menu </a>
        </div>

    </nav>
    <section class="h-txt">
        <span>
            <x>LET'S</x> KEEP IT SIMPLE. </span>
        <br>
        <br>
        <h1>We are the best when it comes to Exotic Cars.</h1>
        
        <br>
        <br>

        <a href="#"> browse the collections </a>    
    </section>
</header>
</body>
</html>
```

#### 2. **error.html**
```error.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 | Page Not Found</title>

    <style>
        *{
            padding: 0;
            margin: 0;
            box-sizing: border-box;
            font-family: sans-serif;
        }

        body{
            width: 100%;
            height: 100vh;
            background: linear-gradient(rgba(2, 1, 8, 0.85), rgba(0, 0, 0, 0.4)),
                        url('wallpaperflare.com_wallpaper (13).jpg');
            background-size: cover;
            background-position: center;
            color: white;
        }

        .container{
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .error-box{
            max-width: 600px;
            padding: 40px;
        }

        .error-box h1{
            font-size: 120px;
            color: rgb(184, 3, 3);
            margin-bottom: 10px;
        }

        .error-box h2{
            font-size: 32px;
            letter-spacing: 4px;
            margin-bottom: 20px;
        }

        .error-box p{
            font-size: 18px;
            color: #ddd;
            margin-bottom: 40px;
        }

        .error-box a{
            text-decoration: none;
            color: white;
            background: rgb(220, 19, 19);
            padding: 12px 28px;
            letter-spacing: 4px;
            transition: 0.4s;
            border-radius: 4px;
        }

        .error-box a:hover{
            background: transparent;
            border: 1px solid rgb(105, 41, 41);
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="error-box">
            <h1>404</h1>
            <h2>PAGE NOT FOUND</h2>
            <p>
                The page you’re looking for doesn’t exist or has been moved.
                Let’s get you back to exploring exotic cars.
            </p>
            <a href="index.html">GO BACK HOME</a>
        </div>
    </div>

</body>
</html>
```

---

### 📦4. **Terraform Deployment**

1.  **Initialize Terraform:**

```bash
terraform init
```

2. **Validate Configuration**

```bash
terraform validate
```

3. **Generate and Review Plan**

```bash
terraform plan
```

4. **Deploy Infrastructure**

```bash
terraform apply
```

* Confirm with 'yes' when prompted

5. **Once completed, Terraform will output the S3 bucket endpoint where your static website is hosted.**

---
---

#### 1. *creating bucket*
<img width="1919" height="1018" alt="1" src="https://github.com/user-attachments/assets/3fa12371-9966-4f6b-a961-fc1e05c6be5d" />

#### 2. *allowing public access*
<img width="1919" height="1017" alt="2" src="https://github.com/user-attachments/assets/2353b9f4-32ce-43fb-825d-64c57ffcb798" />

#### 3. *adding objects in the bucket*
<img width="1919" height="1016" alt="3" src="https://github.com/user-attachments/assets/1102e2ea-7307-4456-bb92-5e87ef664913" />

#### 4. *bucket website endpoint after configuration*
<img width="1911" height="1017" alt="5" src="https://github.com/user-attachments/assets/e17ac173-3ee9-4db2-a354-bdc6dfd00af9" />



---

### 🚀5. **Working Diagram**


      +-------------------------------+
      | Terraform Project Folder      |
      |                               |
      | provider.tf                   |
      | variables.tf                  |
      | bucket.tf                     |
      +---------------+---------------+
                      |
                      | terraform apply
                      v
              +-------------------+
              | AWS Cloud         |
              | (S3 Static Site)  |
              +-------------------+
                      |
                      | Public HTTP Access
                      v
              +-------------------+
              | User Browser      |
              +-------------------+

---

### 🏁6. **Conclusion**

This project demonstrates how to use Terraform to provision a fully automated static website hosting environment on AWS.
Benefits include:

- ✔️ Repeatable Infrastructure — Deploy with a single command
- ✔️ Version Controlled — Infrastructure changes tracked with Git
- ✔️ Cost-Effective Hosting — S3 static website hosting is low cost




