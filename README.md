# Event Ticketing (Jakarta EE 10)

Production-ready Event Management and Ticketing web application built with Jakarta EE 10, JSP/Servlet MVC, JPA/Hibernate, CDI, EJB, JAX-RS, Jakarta Security, Jakarta Mail, and MySQL 8.

## 1. Prerequisites

- Java 17+
- Maven 3.9+
- MySQL 8+
- WildFly 27+ (or Payara 6+)

## 2. Project Structure

```text
event-ticketing/
├── pom.xml
├── src/main/java/com/eventapp/
│   ├── model
│   ├── repository
│   ├── service
│   ├── servlet
│   ├── rest
│   ├── security
│   └── util
├── src/main/resources/
│   ├── META-INF/persistence.xml
│   ├── schema.sql
│   └── data.sql
└── src/main/webapp/
    ├── WEB-INF/web.xml
    └── WEB-INF/views
```

## 3. Database Setup (MySQL)

Run the schema and sample data:

```sql
SOURCE src/main/resources/schema.sql;
SOURCE src/main/resources/data.sql;
```

Default sample password for seeded users is `password` (BCrypt hash in `data.sql`).

## 4. Configure WildFly DataSource

Create a MySQL datasource in WildFly named `java:jboss/datasources/EventDS`.

Example CLI:

```bash
/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql,driver-class-name=com.mysql.cj.jdbc.Driver)
/subsystem=datasources/data-source=EventDS:add(jndi-name=java:jboss/datasources/EventDS,driver-name=mysql,connection-url=jdbc:mysql://localhost:3306/event_ticketing?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC,user-name=root,password=YOUR_PASSWORD,min-pool-size=5,max-pool-size=20,enabled=true)
```

Optional mail session used by ticket confirmation:

```bash
/subsystem=mail/mail-session=default/server=smtp:add(outbound-socket-binding-ref=mail-smtp,username=your_user,password=your_pass,ssl=false,tls=true)
```

The app looks up `java:jboss/mail/Default`.

## 5. Build

```bash
mvn clean package
```

Output WAR:

```text
target/event-ticketing.war
```

## 6. Deploy on WildFly

Copy WAR to `WILDFLY_HOME/standalone/deployments/` or use CLI:

```bash
deploy target/event-ticketing.war --force
```

Then open:

- Web UI: `http://localhost:8080/event-ticketing/home`
- REST API base: `http://localhost:8080/event-ticketing/api`

## 7. REST Endpoints

- `GET /api/events`
- `GET /api/events/{id}`
- `GET /api/events/search?q=...`
- `POST /api/tickets/purchase`
- `GET /api/tickets/{participantId}`
- `DELETE /api/tickets/{id}`
- `GET /api/stats/summary`

## 8. Security Notes

- Session and role checks for organizer/admin URLs via `AuthFilter`
- CSRF token validation on all POST forms
- Password hashing and verification with BCrypt
- JSP output escaped with JSTL `<c:out>`/`fn:escapeXml`

## 9. Quick Test Accounts

- Admin: `admin1@eventapp.com` / `password`
- Organizer: `organizer1@eventapp.com` / `password`
- Participant: `participant1@eventapp.com` / `password`
