

PROYECTO CIVIX  



Módulo: Registro de Incidencias
Detalle del requerimiento:
El sistema a desarrollar es una plataforma integral para la gestión, seguimiento y control de incidentes atendidos por operadores, agentes de campo y supervisores. El objetivo es centralizar la información de los reportes, optimizar la atención de los casos y asegurar continuidad operativa durante todo el flujo de respuesta.
El operador será responsable de registrar incidentes mediante un formulario web dinámico, cuyos campos se adaptan según el tipo de incidencia (personas desaparecidas, robos de vehículos, vehículos sospechosos, personas sospechosas, requisitoriados, entre otros). La interfaz del operador estará estructurada en tres columnas:
1.	Formulario del ticket, donde puede crear o editar incidencias, visualizar datos del reportante, descripción del incidente, tipo, fecha, hora y ubicación.
2.	Chat del ticket, donde se integrarán mensajes del agente y del operador.
3.	Mapa interactivo, con búsqueda de direcciones, geolocalización y autocompletado automático de la ubicación del incidente.
El sistema permitirá al operador visualizar todos los tickets creados por él o asignados por un supervisor. Además, se mostrará una lista de agentes activos, indicando para cada uno:
•	Nombre del agente,
•	Ticket que está atendiendo,
•	Estado del ticket,
•	Disponibilidad o estado operativo.
Los agentes de campo reportarán actualizaciones del incidente a través de un bot de Telegram, enviando:
•	Texto descriptivo del progreso,
•	Fotos y videos,
•	Audio,
•	Ubicación GPS,
•	Confirmación de acciones ejecutadas (en camino, en atención, incidente resuelto).
Toda la información enviada desde Telegram debe integrarse automáticamente en el ticket correspondiente, actualizando el chat del operador en tiempo real y almacenando la evidencia como parte del registro del incidente.
Por su parte, el supervisor contará con una vista dedicada: un dashboard de monitoreo, donde podrá visualizar todos los operadores, la carga de tickets asignada a cada uno y los estados de los incidentes. El sistema debe destacar a los operadores cuyo turno está por finalizar, para anticipar acciones de redistribución de carga.
El supervisor podrá reasignar tickets pendientes de operadores próximos a culminar turno. La reasignación debe ser múltiple y permitir seleccionar varios tickets para enviarlos a otro operador o agente disponible. Cuando la reasignación se confirme, el sistema debe:
•	Quitar los tickets del operador original,
•	Asignarlos al nuevo operador o agente,
•	Registrar en el historial del ticket la información de trasferencia (operador origen, destino, fecha y hora),
•	Actualizar en tiempo real la vista del operador y del supervisor.
El sistema debe mantener sincronización continua entre los módulos de operadores, agentes y supervisores, permitiendo una operación fluida, coordinada y sin pérdida de información. Asimismo, debe permitir actualizaciones en tiempo real o mediante un mecanismo eficiente de refresco.
En conjunto, este requerimiento establece un ecosistema funcional que mejora la atención de incidentes, consolida la información operativa en una sola plataforma, y habilita un flujo de comunicación directo con los agentes por Telegram, garantizando continuidad, trazabilidad y respuesta efectiva ante cualquier situación reportada.

Historias de Usuario
1.	HU-OP-01 – Registrar y gestionar incidentes (tickets)
Como usuario operador 
quiero registrar incidentes en un formulario web y ver todos los tickets que tengo asignados
para gestionar de forma centralizada los casos que atiendo, tanto los que yo cree como los que me asignó el supervisor.

Criterios de aceptación:
1.1.	 Estructura de la Pantalla
•	La interfaz principal debe estar dividida en tres columnas:
o	Columna 1: Formulario del ticket y lista de agentes con tickets asignados.
o	Columna 2: Chat asociado al ticket seleccionado.
o	Columna 3: Vista del mapa interactivo.
1.2.	 Funcionalidad del Formulario del Ticket
•	El formulario ubicado en la parte superior de la primera columna debe permitir:
o	Crear un nuevo ticket a partir de una llamada o notificación.
o	Editar un ticket existente cuando el usuario seleccione uno desde la lista.

1.3.	Creación de un Nuevo Ticket
•	Al seleccionar el botón “Crear Ticket”, el sistema debe:
o	Generar automáticamente un número de ticket único.
o	Agregar el nuevo ticket a la lista de tickets en la parte superior de la primera columna.
o	Cargar automáticamente el formulario del ticket en modo edición para iniciar el registro de datos.
o	Permitir completar los siguientes datos:
	Datos del reportante.
	Descripción del incidente.
	Tipo de incidencia (desplegable con opciones):
	Persona Desaparecida
	Persona Sospechosa
	Persona Requisitoriada
	Robo de Vehículo
	Vehículo Sospechoso
	Otra incidencia
	Fecha y hora de registro (valor por defecto).
	Ubicación del incidente (autocompletada desde el mapa).
o	Asociar automáticamente el ticket al operador que lo registró.
1.4.	Visualización de Tickets del Operador
•	El operador debe poder visualizar todos los tickets relacionados a él, incluyendo:
o	Tickets creados por el operador.
o	Tickets asignados por el supervisor.
•	En la interfaz se debe mostrar:
o	Estado del ticket (abierto, asignado, en atención, cerrado).
o	Origen del ticket (creado por operador o asignado por supervisor).

1.5.	Lista de Agentes con Tickets Activos
•	En la parte inferior de la primera columna, el operador debe visualizar una lista de agentes que tienen un ticket asignado, incluyendo:
o	Nombre del agente.
o	Número del ticket que está atendiendo.
o	Estado actual del ticket (por ejemplo: en atención).
1.6.	Selección de un Ticket
•	Cuando el operador seleccione un ticket desde la lista:
o	El formulario superior debe cargarse automáticamente con la información del ticket.
o	La segunda columna debe mostrar el chat correspondiente al ticket seleccionado.
o	La tercera columna debe mostrar el mapa, sin perder el contexto actual.
1.7.	 Mapa con Búsqueda y Autocompletado
•	El mapa en la tercera columna debe incluir un campo de búsqueda de direcciones.
•	Cuando el operador escriba y seleccione una dirección:
o	El mapa debe centrar la vista en la ubicación seleccionada.
o	El sistema debe autocompletar el campo “Ubicación del incidente” en el formulario del ticket.
•	La selección de ubicación debe mantenerse sincronizada con el formulario mientras el ticket esté abierto.

1.8.	 Comportamiento Dinámico del Formulario
•	El formulario del ticket debe actualizarse dinámicamente en función del ticket seleccionado.
•	Los campos deben cambiar entre modo crear o editar según corresponda.
•	Debe permitir continuar el registro inmediatamente después de la creación de un ticket nuevo.

Prototipo: https://nine-one-one-ops-vue.lovable.app/ 

2.	HU-OP-02 – Coordinar con agentes mediante chat y recibir notificaciones
Como operador
quiero comunicarme con los agentes mediante un chat asociado al ticket y recibir notificaciones visuales cuando un agente escriba en otro ticket
para coordinar la atención de los incidentes en tiempo real sin perder mensajes importantes. 

Criterios de aceptación
•	La segunda columna de la pantalla del operador debe mostrar el chat asociado al ticket seleccionado.
•	El chat debe permitir:
o	Enviar mensajes desde el operador hacia el agente.
o	Recibir mensajes desde el agente hacia el operador.
•	Todos los mensajes deben quedar vinculados al número de ticket, formando parte del historial del incidente.
•	Si el agente envía un mensaje en un ticket diferente al que el operador está viendo actualmente, el sistema debe:
o	Hacer que el botón/cuadrícula (o elemento visual) de ese ticket parpadee o muestre un indicador visual claro de “nuevo mensaje”.
•	El indicador/parpadeo debe:
o	Activarse cada vez que llegue un mensaje nuevo no leído de un agente.
o	Mantenerse visible hasta que el operador abra ese ticket en particular.
•	Al abrir el ticket:
o	El sistema debe marcar los mensajes como leídos.
o	El parpadeo o indicador de “nuevo mensaje” debe desaparecer.
•	Si el agente sigue escribiendo en ese ticket después de haber sido leído:
o	El sistema debe volver a activar el indicador/parpadeo por cada nuevo mensaje no leído.
•	Debe haber un botón para cerrar el ticket del incidente en donde me pida colocar el motivo del cierre, una vez cerrado un ticket debe desaparecer de la lista de ticket que se muestren en la parte superior de la pantalla.


Prototipo: https://nine-one-one-ops-vue.lovable.app/

3.	HU-OP-03 – Ver mapa de agentes activos, asignar tickets y cerrarlos
Como operador
quiero ver en un mapa a los agentes activos sin ticket asignado y poder asignarles tickets o cerrar los ya resueltos
para garantizar que cada incidente sea atendido por un agente disponible y quede correctamente cerrado.

Criterios de aceptación
•	La tercera columna de la pantalla debe mostrar un mapa en tiempo real con un filtro de búsqueda que me permita colocar una ubicación y por defecto se autocomplete el campo ubicación de la primera columna.
•	En el mapa solo deben mostrarse como puntos los agentes activos que no tienen un ticket asignado, de acuerdo a lo que reporten desde Telegram.
•	Por cada punto (agente) mostrado en el mapa, el operador debe poder ver:
o	Nombre del agente.
o	Ubicación actual.
o	Hora de la última actualización o de activación.
o	Estado de disponibilidad (ej.: “Activo sin ticket”).
•	Desde el mapa, el operador debe poder asignar un ticket a un agente activo:
o	Seleccionando un ticket pendiente de asignación.
o	Seleccionando un agente (punto del mapa) disponible.
•	Al asignar un ticket:
o	El estado del agente debe pasar de “sin ticket asignado” a “con ticket asignado” (por lo que dejaría de aparecer como punto libre en el mapa y aparecería en la lista inferior de la columna 1, como “agente con ticket asignado”).
o	El agente debe recibir el ticket en su chat de Telegram con la información básica del incidente.
•	Cuando el agente confirme vía chat que el incidente ha sido solucionado:
o	El operador debe poder escribir un mensaje de cierre o resumen en el ticket (por ejemplo, en el formulario o sección de cierre).
o	Al confirmar el cierre, el estado del ticket debe cambiar a “Cerrado”.
o	El ticket debe dejar de aparecer en la vista de tickets activos del operador.
o	El mensaje de cierre debe quedar registrado en el historial del ticket.

Prototipo: https://nine-one-one-ops-vue.lovable.app/

4.	HU-AG-01 – Gestionar mi disponibilidad y ubicación desde Telegram
Como agente
quiero indicar desde Telegram si estoy activo o no
para que el operador pueda verme como disponible y visualizar mi ubicación en el mapa cuando pueda atender incidentes.
Criterios de aceptación
•	El agente debe conectarse exclusivamente mediante Telegram, no vía web.
•	El agente debe poder enviar un comando o acción (por ejemplo: /activo) para marcarse como activo.
•	Cuando el agente se marque como activo:
o	Su estado debe reflejarse en el sistema como “Disponible”.
o	Su ubicación debe mostrarse en el mapa del operador como un punto, siempre que no tenga un ticket asignado.
•	Si el agente obtiene un ticket asignado:
o	Debe dejar de aparecer como agente “sin ticket asignado” en el mapa de la columna 3.
o	Debe aparecer en la lista de “agentes con ticket asignado” en la parte inferior de la columna 1 (vista del operador).
•	El agente también debe poder enviar un comando (por ejemplo: /inactivo) para indicar que ya no está disponible:
o	Dejaría de aparecer como punto activo en el mapa.
o	No debería ser asignado a nuevos tickets.
Prototipo:
5.	HU-AG-02 – Recibir y gestionar tickets asignados desde Telegram
Como agente
quiero recibir en mi chat de Telegram los tickets que me asigne el operador y comunicar el estado del incidente
para atender los incidentes asignados y permitir que el operador tome decisiones sobre el cierre.

Criterios de aceptación
•	Cuando el operador asigne un ticket a un agente:
o	El agente debe recibir en su chat de Telegram un mensaje con:
	Número de ticket.
	Descripción del incidente.
	Ubicación del incidente.
	Información relevante registrada por el operador.
•	El agente debe poder ver, en su chat, los tickets vigentes que tiene asignados (por ejemplo, mediante mensajes o listados generados por comando).
•	El agente debe poder enviar mensajes de actualización al operador, tales como:
o	Estado del incidente (en camino, en atención, pendiente, etc.).
o	Observaciones relevantes del caso.
•	El agente debe poder confirmar que el incidente se solucionó, ya sea:
o	Enviando un mensaje claro (ej.: “Incidente resuelto”) o
o	Usando un comando predefinido (ej.: /resuelto), según se defina.
•	La confirmación de resolución debe:
o	Llegar al operador en el chat del ticket.
o	Habilitar al operador para cerrar el ticket (ver HU-OP-03).
Prototipo:
6.	HU-SUP-01 – Visualizar dashboard de operadores y tickets
Como supervisor
quiero ver un dashboard que muestre a todos los operadores y los tickets que tiene asignado cada uno
para monitorear la carga de trabajo y el estado general de los incidentes.

Criterios de aceptación
•	El supervisor debe tener acceso a un dashboard inicial.
•	El dashboard debe mostrar:
o	Lista de todos los operadores.
o	Cantidad de tickets que tiene cada operador.
•	El supervisor debe poder ver, por operador:
o	Listado de tickets asignados.
o	Estado de cada ticket (abierto, asignado, en atención, cerrado).
•	El dashboard debe actualizarse periódicamente (casi en tiempo real) o bajo un mecanismo de actualización definido.
•	El sistema debe poder marcar o destacar los operadores cuyo turno esté por finalizar (según reglas de negocio de horarios).

Prototipo: https://supervise-shift-orange.lovable.app

7.	HU-SUP-02 – Reasignar tickets de operadores cuyo turno termina
Como supervisor
quiero reasignar los tickets pendientes de operadores cuyo turno va a terminar
para asegurar que todos los incidentes sigan siendo atendidos sin interrupciones.

Criterios de aceptación
•	Los tickets pendientes de atención de estos operadores deben:
o	Aparecer automáticamente en el dashboard del supervisor.
•	El supervisor debe poder seleccionar uno o varios de estos tickets y reasignarlos a otro operador disponible.
•	Al confirmar la reasignación:
o	Los tickets deben dejar de contarse en la carga del operador original.
o	Los tickets deben aparecer como asignados al nuevo operador.
•	La reasignación debe quedar registrada en el historial de cada ticket:
o	Operador origen.
o	Operador destino.
o	Fecha y hora de la reasignación.
•	Los operadores afectados deben ver actualizados sus listados de tickets en su vista de trabajo.

Prototipo: https://supervise-shift-orange.lovable.app	







