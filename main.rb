require 'json'
require 'rest-client'

#aqui ficam os dados da url

url_da_api = 'https://delivery-center-recruitment-ap.herokuapp.com/'

#pegando a data atual e transformando no formato pedido
data_atual = Time.now
data_atual = data_atual.strftime("%Ih%M - %d/%m/%Y")

#header para envio da API
cabecalho = {
    'Accept': 'application/json',
    'Content-type': 'application/json',
    'X-Sent': data_atual
}


#JSON com dados de entrada para ser tratado
payload =  JSON.parse('{
    "id": 9987071,
    "store_id": 282,
    "date_created": "2019-06-24T16:45:32.000-04:00",
    "date_closed": "2019-06-24T16:45:35.000-04:00",
    "last_updated": "2019-06-25T13:26:49.000-04:00",
    "total_amount": 49.9,
    "total_shipping": 5.14,
    "total_amount_with_shipping": 55.04,
    "paid_amount": 55.04,
    "expiration_date": "2019-07-22T16:45:35.000-04:00",
    "total_shipping": 5.14,
    "order_items": [
      {
        "item": {
          "id": "IT4801901403",
          "title": "Produto de Testes"
        },
        "quantity": 1,
        "unit_price": 49.9,
        "full_unit_price": 49.9
      }
    ],
    "payments": [
      {
        "id": 12312313,
        "order_id": 9987071,
        "payer_id": 414138,
        "installments": 1,
        "payment_type": "credit_card",
        "status": "paid",
        "transaction_amount": 49.9,
        "taxes_amount": 0,
        "shipping_cost": 5.14,
        "total_paid_amount": 55.04,
        "installment_amount": 55.04,
        "date_approved": "2019-06-24T16:45:35.000-04:00",
        "date_created": "2019-06-24T16:45:33.000-04:00"
      }
    ],
    "shipping": {
      "id": 43444211797,
      "shipment_type": "shipping",
      "date_created": "2019-06-24T16:45:33.000-04:00",
      "receiver_address": {
        "id": 1051695306,
        "address_line": "Rua Fake de Testes 3454",
        "street_name": "Rua Fake de Testes",
        "street_number": "3454",
        "comment": "teste",
        "zip_code": "85045020",
        "city": {
          "name": "Cidade de Testes"
        },
        "state": {
          "name": "São Paulo"
        },
        "country": {
          "id": "BR",
          "name": "Brasil"
        },
        "neighborhood": {
          "id": null,
          "name": "Vila de Testes"
        },
        "latitude": -23.629037,
        "longitude": -46.712689,
        "receiver_phone": "41999999999"
      }
    },
    "status": "paid",
    "buyer": {
      "id": 136226073,
      "nickname": "JOHN DOE",
      "email": "john@doe.com",
      "phone": {
        "area_code": 41,
        "number": "999999999"
      },
      "first_name": "John",
      "last_name": "Doe",
      "billing_info": {
        "doc_type": "CPF",
        "doc_number": "09487965477"
      }
    }
  }
  ')

  
  #tratamento de informações dentro do objeto shipping do JSON
  tratando_entrega_para_obter_informacoes_de_endereco = payload['shipping']


  #tratamento de informações dentro do objeto receiver_adress do JSON
  trantando_endereco_para_receber_informacoes_separadas =  tratando_entrega_para_obter_informacoes_de_endereco['receiver_address']

 
  #tratamento de informações dentro do objeto country do JSON
  recebendo_pais = trantando_endereco_para_receber_informacoes_separadas['country']
  recebendo_sigla_do_pais = recebendo_pais['id']

  #tratamento de informações dentro do objeto state do JSON
  tratando_estado = trantando_endereco_para_receber_informacoes_separadas['state']
  recebendo_estado = tratando_estado['name']

  #tratamento de informações dentro do objetocity do JSON
  tratando_cidade = trantando_endereco_para_receber_informacoes_separadas['city']
  recebendo_cidade = tratando_cidade['name']


 #JSON tratado para envio na API      
 processamento = {

    "externalCode": payload['id'],
    "storeId": payload['store_id'],
    "subTotal": sprintf('%.2f', payload['total_amount']),
    "deliveryFee": payload['total_shipping'],
    "total_shipping": payload['total_shipping'],
    "total": sprintf('%.2f', payload['total_amount_with_shipping']),
    "country": recebendo_sigla_do_pais,
    "state": recebendo_estado,
    "city": recebendo_cidade,
    "district": "Bairro Fake",
    "street": "Rua de Testes Fake",
    "complement": "galpao",
    "latitude": -23.629037,
    "longitude":  -46.712689,
    "dtOrderCreate": "2019-06-27T19:59:08.251Z",
    "postalCode": "85045020",
    "number": "0",
    "customer": {
        "externalCode": "136226073",
        "name": "JOHN DOE",
        "email": "john@doe.com",
        "contact": "41999999999"
    },
    "items": [
        {
            "externalCode": "IT4801901403",
            "name": "Produto de Testes",
            "price": 49.9,
            "quantity": 1,
            "total": 49.9,
            "subItems": []
        }
    ],
    "payments": [
        {
            "type": "CREDIT_CARD",
            "value": 55.04
        }
    ]
} 


 
# os codigos abaixo foram ultilizados para fazer os testes de montagem do JSON

puts processamento
puts cabecalho

#retorno_da_api = RestClient.post(url_da_api, cabecalho, processamento) 

#puts JSON.parse(retorno_da_api.body)

