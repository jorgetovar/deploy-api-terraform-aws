import json
import boto3

dynamodb = boto3.resource('dynamodb')

def factory(code, response):
    return {
        'statusCode': code,
        'headers': {
            'Content-Type': 'application/json',
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": True
        },
        'body': json.dumps(response)
    }

def query_item(id):
    table = dynamodb.Table('EpamTable')
    response = table.get_item(Key={'id': id})
    print(response)
    item = response['Item']
    return item


def handler(event, context):
    return factory(200, {'item': query_item('1')})

