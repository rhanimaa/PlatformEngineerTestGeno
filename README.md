This code : 
- Automatically processes .jpg files uploaded to Bucket A.
- Removes EXIF metadata using a Python Lambda function.
- Saves processed images to Bucket B with the same file path.
- IAM users:
  User A: Read/Write access to Bucket A.
  User B: Read access to Bucket B.
