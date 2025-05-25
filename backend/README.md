# MongoDB Collection Schemas

Este repositório contém os schemas de validação das coleções usadas em um projeto MongoDB. Os schemas estão no formato `$jsonSchema` e podem ser utilizados ao criar coleções com validação no MongoDB.

## Coleções

- usuarios
- desafios
- datas_importantes
- encontros
- sugestoes_celebracao

## Como usar

Você pode aplicar os schemas ao criar uma nova coleção com:

```js
db.createCollection("usuarios", {
  validator: { $jsonSchema: /* conteúdo do arquivo usuarios.schema.json */ }
});
```

Ou colar diretamente no MongoDB Compass na aba "Validation".
