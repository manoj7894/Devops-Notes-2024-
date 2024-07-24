import boto3

# Specify the region_name explicitly when creating the client
client = boto3.client('s3', region_name='ap-south-1')

# # Create bucket with a location constraint
# response = client.create_bucket(
#     Bucket='manoj-3003-python',
#     CreateBucketConfiguration={
#         'LocationConstraint': 'ap-south-1'  # Specify your desired region here
#     }
# )

# print(response)

response = client.get_bucket_acl(
    Bucket='manoj-3003-python',
)

print(response)
