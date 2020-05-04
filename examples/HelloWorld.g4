grammar HelloWorld;

hello : 'Hello';
world : 'World';
hello_world : hello hello_world world | ', ';
