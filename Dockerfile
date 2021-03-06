FROM sonarqube:7.9-community

USER root
ENV SONAR_AUTH_AAD_VERSION=1.2.0 \
    SONAR_CSHARP_VERSION=8.6.1.17183

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	gosu \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -LJO "https://github.com/SonarSource/sonar-dotnet/releases/download/${SONAR_CSHARP_VERSION}/sonar-csharp-plugin-${SONAR_CSHARP_VERSION}.jar" -O \
    && curl -LJO "https://github.com/SonarQubeCommunity/sonar-auth-aad/releases/download/${SONAR_AUTH_AAD_VERSION}/sonar-auth-aad-plugin-${SONAR_AUTH_AAD_VERSION}.jar" -O \  
    
	&& rm $SONARQUBE_HOME/extensions/plugins/sonar-csharp-plugin*.jar  \
    && mv *.jar $SONARQUBE_HOME/extensions/plugins \
    && ls -lah $SONARQUBE_HOME/extensions/plugins

# Custom Sonarqube properties 
COPY ./sonar.properties /opt/sonarqube/conf/

# Configure Azure Web App database entrypoint
COPY --chown=sonarqube:sonarqube entrypoint.sh ./bin/
RUN chmod +x ./bin/entrypoint.sh
ENTRYPOINT ["./bin/entrypoint.sh"]
