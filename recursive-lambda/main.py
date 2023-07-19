import boto3, os, json

QUEUE_URL = os.environ['QUEUE_URL']

def processMsg(msg):
  body = json.loads(msg['body'])
  if 'counter' in body:
    return body['counter']
  return 0

def handler(event, context):
  counter = 0
  # In case there are multiple messages
  # select the largest counter
  for msg in event['Records']:
    counterId = processMsg(msg)
    if counterId > counter:
      counter = counterId
  
  if counter > 100:
    print("Counter is %d, exiting" % counter)
    return {
      'statusCode': 200,
      'body': "Counter reached more than 1000"
    }
  
  print("Sending count %d" % (counter + 1))
  q = boto3.client('sqs')
  q.send_message(QueueUrl=QUEUE_URL, MessageBody=json.dumps({'counter': counter + 1}))
  return {
      'statusCode': 200,
      'body': "New counter sent: %d" % (counter + 1)
    }