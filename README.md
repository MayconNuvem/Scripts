# Scripts

# Pré-requisitos
Ter a função de Microsoft Entra para criar uma aplicação no Azure. Por exemplo, Administrador de Aplicações.

# Passo 1: criar uma aplicação no Azure
1. Entre no portal do Azure.

2. Procure Registros de aplicativo e navegue para Registros de aplicativo.

3. Selecione Novo registro.

4. Escolha um nome para a sua aplicação e, em seguida, selecione Registar.

5. Na página da sua aplicação, aceda a Gerir > Permissões > de API Adicionar APIs de permissão > que a minha organização utiliza.

6. Na página Pedir permissões da API , procure WindowsDefenderATP e selecione-o.

7. Selecione o tipo de permissões necessárias e, em seguida, selecione Adicionar permissões.

 - Permissões delegadas – inicie sessão com a sua aplicação como se fosse um utilizador.

 - Permissões de aplicação – aceda à API como um serviço.

8. Selecione as permissões adequadas para a sua aplicação. Para determinar de que permissão precisa, veja a secção Permissões na API que está a chamar. Eis dois exemplos:

 - Para executar consultas avançadas, selecione Executar consultas avançadas. (https://learn.microsoft.com/pt-br/defender-endpoint/api/run-advanced-query-api)

 - Para isolar um dispositivo, selecione Isolar máquina. (https://learn.microsoft.com/pt-br/defender-endpoint/api/isolate-machine)

9. Selecione Adicionar permissão.

# Passo 2: adicionar um segredo à sua aplicação
Esta secção descreve a autenticação da sua aplicação através de um segredo da aplicação. Para autenticar a sua aplicação com um certificado, veja Criar um certificado público autoassinado para autenticar a sua aplicação.

1. Na página da aplicação, selecione Certificados & segredos>Novo segredo do cliente.

2. No painel Adicionar um segredo do cliente , adicione uma descrição e uma data de expiração.

3. Selecione Adicionar.

4. Copie o Valor do segredo que criou. Não poderá obter este valor depois de sair da página.

5. Na página de descrição geral da aplicação, copie o ID da Aplicação (cliente) e o ID do Diretório (inquilino). Precisa deste ID para autenticar a sua aplicação.

6. Anote o ID da aplicação e o ID do inquilino. Na página da aplicação, aceda a Descrição geral e copie o seguinte.


# Fonte: https://learn.microsoft.com/pt-br/defender-endpoint/api/exposed-apis-create-app-webapp?tabs=PowerShell
