AWS.config(access_key_id:     ENV["S3_ACCESS_KEY"],
           secret_access_key: ENV["S3_SECRET_KEY"])
           
S3_BUCKET = ENV["S3_BUCKET"]  