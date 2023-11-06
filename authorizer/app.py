import json
import os
import pymysql
import jwt


db_config = {
    "host": os.getenv('DB_HOST'),
    "port": int(os.getenv('DB_PORT')),
    "user": os.getenv('DB_USER'),
    "password": os.getenv('DB_PASSWORD'),
    "database": os.getenv('DB_NAME'),
}

# Chave secreta para assinar o JWT
SECRET_KEY = os.getenv('JWT_SECRET_KEY')

def lambda_handler(event, context):

    # Verifica se o evento contém a query param "cpf"
    if "queryStringParameters" in event and "cpf" in event["queryStringParameters"]:
        cpf = event["queryStringParameters"]["cpf"]
        # Conectar ao banco de dados MySQL
        cursor = None
        try:
            conn = pymysql.connect(**db_config)
            cursor = conn.cursor()
            # Consultar o banco de dados para verificar se o CPF existe
            cursor.execute("SELECT name, cpf, email FROM customer WHERE cpf = %s", (cpf,))
            row = cursor.fetchone()
            if row:
                name, cpf, email = row
                # Gerar um JWT com os dados do perfil
                payload = {
                    "name": name,
                    "cpf": cpf,
                    "email": email
                }
                jwt_token = jwt.encode(payload=payload,key=SECRET_KEY, algorithm="HS256")
                return {
                    "statusCode": 200,
                    "body": json.dumps({"jwt": jwt_token})
                }
            else:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"message": "CPF não encontrado"})
                }
        except Exception as e:
            return {
                "statusCode": 500,
                "body": json.dumps({"message": "Erro no servidor"})
            }
        finally:
            if cursor:
                cursor.close()
                conn.close()
    else:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Parâmetro 'cpf' não encontrado"})
        }
