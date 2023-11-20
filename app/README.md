### Monitoring Microservices Metrics & Health inside microservices network using Micrometer, Prometheus, Grafana
---

**Description:** This repository has six maven projects with the names **accounts, loans, cards, configserver, eurekaserver, gatewayserver** . All these microservices will be updated in this section to implement monitoring metrics & health inside microservices network using **micrometer, 
prometheus, grafana.**

  ### \accounts\docker-compose\monitoring\prometheus.yml
```yaml
  global:
  scrape_interval:     5s # Set the scrape interval to every 5 seconds.
  evaluation_interval: 5s # Evaluate rules every 5 seconds.
scrape_configs:
  - job_name: 'accounts'
    metrics_path: '/actuator/prometheus'
    static_configs:
    - targets: ['accounts:8080']
  - job_name: 'loans'
    metrics_path: '/actuator/prometheus'
    static_configs:
    - targets: ['loans:8090']
  - job_name: 'cards'
    metrics_path: '/actuator/prometheus'
    static_configs:
    - targets: ['cards:9000']
  ```
- Now in the same folder where **prometheus.yml** is present, create a **docker-compose.yml** file with the following content,
### \accounts\docker-compose\monitoring\docker-compose.yml
```yaml
version: "3.8"

services:

  grafana:
    image: "grafana/grafana:latest"
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=password
    networks:
     - dobahoang
    depends_on:
      - prometheus  

  prometheus:
   image: prom/prometheus:latest
   ports:
      - "9090:9090"
   volumes:
    - ./prometheus.yml:/etc/prometheus/prometheus.yml
   networks:
    - dobahoang
   
  zipkin:
    image: openzipkin/zipkin
    mem_limit: 700m
    ports:
      - "9411:9411"
    networks:
     - dobahoang

  configserver:
    image: dobahoang/configserver:latest
    mem_limit: 700m
    ports:
      - "8071:8071"
    networks:
     - dobahoang
    depends_on:
      - zipkin
    environment:
      SPRING_PROFILES_ACTIVE: default
      # SPRING_ZIPKIN_BASEURL: http://zipkin:9411/
      MANAGEMENT_ZIPKIN_TRACING_ENDPOINT: http://zipkin:9411/api/v2/spans
      
  eurekaserver:
    image: dobahoang/eurekaserver:latest
    mem_limit: 700m
    ports:
      - "8070:8070"
    networks:
     - dobahoang
    depends_on:
      - configserver
    deploy:
      restart_policy:
        condition: on-failure
        delay: 15s
        max_attempts: 3
        window: 120s
    environment:
      SPRING_APPLICATION_NAME: eurekaserver
      SPRING_PROFILES_ACTIVE: default
      SPRING_CONFIG_IMPORT: configserver:http://configserver:8071/
      # SPRING_ZIPKIN_BASEURL: http://zipkin:9411/
      MANAGEMENT_ZIPKIN_TRACING_ENDPOINT: http://zipkin:9411/api/v2/spans

  accounts:
    image: dobahoang/accounts:latest
    mem_limit: 700m
    ports:
      - "8080:8080"
    networks:
      - dobahoang
    depends_on:
      - configserver
      - eurekaserver
    deploy:
      restart_policy:
        condition: on-failure
        delay: 30s
        max_attempts: 3
        window: 120s
    environment:
      SPRING_APPLICATION_NAME: accounts
      SPRING_PROFILES_ACTIVE: default
      SPRING_CONFIG_IMPORT: configserver:http://configserver:8071/
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eurekaserver:8070/eureka/
      # SPRING_ZIPKIN_BASEURL: http://zipkin:9411/
      MANAGEMENT_ZIPKIN_TRACING_ENDPOINT: http://zipkin:9411/api/v2/spans
  
  loans:
    image: dobahoang/loans:latest
    mem_limit: 700m
    ports:
      - "8090:8090"
    networks:
      - dobahoang
    depends_on:
      - configserver
      - eurekaserver
    deploy:
      restart_policy:
        condition: on-failure
        delay: 30s
        max_attempts: 3
        window: 120s
    environment:
      SPRING_APPLICATION_NAME: loans
      SPRING_PROFILES_ACTIVE: default
      SPRING_CONFIG_IMPORT: configserver:http://configserver:8071/
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eurekaserver:8070/eureka/
      # SPRING_ZIPKIN_BASEURL: http://zipkin:9411/
      MANAGEMENT_ZIPKIN_TRACING_ENDPOINT: http://zipkin:9411/api/v2/spans
    
  cards:
    image: dobahoang/cards:latest
    mem_limit: 700m
    ports:
      - "9000:9000"
    networks:
      - dobahoang
    depends_on:
      - configserver
      - eurekaserver
    deploy:
      restart_policy:
        condition: on-failure
        delay: 30s
        max_attempts: 3
        window: 120s
    environment:
      SPRING_APPLICATION_NAME: cards
      SPRING_PROFILES_ACTIVE: default
      SPRING_CONFIG_IMPORT: configserver:http://configserver:8071/
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eurekaserver:8070/eureka/
      # SPRING_ZIPKIN_BASEURL: http://zipkin:9411/
      MANAGEMENT_ZIPKIN_TRACING_ENDPOINT: http://zipkin:9411/api/v2/spans
      
  gatewayserver:
    image: dobahoang/gatewayserver:latest
    mem_limit: 700m
    ports:
      - "8072:8072"
    networks:
      - dobahoang
    depends_on:
      - configserver
      - eurekaserver
      - cards
      - loans
      - accounts
    deploy:
      restart_policy:
        condition: on-failure
        delay: 45s
        max_attempts: 3
        window: 180s
    environment:
      SPRING_APPLICATION_NAME: gatewayserver
      SPRING_PROFILES_ACTIVE: default
      SPRING_CONFIG_IMPORT: configserver:http://configserver:8071/
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eurekaserver:8070/eureka/
      # SPRING_ZIPKIN_BASEURL: http://zipkin:9411/
      MANAGEMENT_ZIPKIN_TRACING_ENDPOINT: http://zipkin:9411/api/v2/spans

networks:
  dobahoang:
```
- Open the command line tool where the docker-compose.yml is present and run the docker compose command **"docker-compose up"** to start all the microservices containers with a single command. All the running containers can be validated by running a docker command **"docker ps"**.
- Open the URL http://localhost:9090/targets/ inside a browser and validate all the details, graphs present inside prometheus like we discussed in the course.
- Open the URL http://localhost:3000/login/ inside a browser and enter the login details(**admin/password**) of Grafana like we discussed in the course. Inside Grafana provide prometheus details, build custom dashboards, alerts 
- Stop all the running containers by executing the docker compose command "docker-compose down" from the location where docker-compose.yml is present.

java17
