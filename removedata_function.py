import boto3
from PIL import Image
from io import BytesIO
import os

s3 = boto3.client('s3')

def remove_exif(image_data):
    image = Image.open(BytesIO(image_data))
    # Remove EXIF metadata
    data = list(image.getdata())
    image_without_exif = Image.new(image.mode, image.size)
    image_without_exif.putdata(data)
    
    # Save the image to a BytesIO object
    buffer = BytesIO()
    image_without_exif.save(buffer, format="JPEG")
    buffer.seek(0)
    return buffer

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source_key = event['Records'][0]['s3']['object']['key']
    
    # Download the image
    response = s3.get_object(Bucket=source_bucket, Key=source_key)
    image_data = response['Body'].read()
    
    # Remove EXIF metadata
    processed_image = remove_exif(image_data)
    
    # Upload to destination bucket
    destination_bucket = os.environ['DESTINATION_BUCKET']
    s3.put_object(Bucket=destination_bucket, Key=source_key, Body=processed_image)
    
    return {
        'statusCode': 200,
        'body': 'EXIF metadata removed and file saved to destination bucket.'
    }
