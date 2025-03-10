Removal of EXIF metadata from .jpg images 
This project automates the removal of EXIF metadata from .jpg images uploaded to an S3 bucket. It uses AWS (S3, Lambda) and Terraform for infrastructure as code. Processed images are saved to a second S3 bucket.

- Automatically processes .jpg files uploaded to Bucket A.
- Removes EXIF metadata using a Python Lambda function.
- Saves processed images to Bucket B with the same file path.
- IAM users:
  User A: Read/Write access to Bucket A.
  User B: Read access to Bucket B.
