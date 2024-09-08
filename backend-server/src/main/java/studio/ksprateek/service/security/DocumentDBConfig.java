package studio.ksprateek.service.security;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import java.io.ByteArrayInputStream;
import java.nio.file.Files;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class DocumentDBConfig extends AbstractMongoClientConfiguration {


    private static final String CERT_FILE_PATH = "db-certs/global-bundle.pem";
    private static final String END_OF_CERTIFICATE_DELIMITER = "-----END CERTIFICATE-----";
    private static final String CERTIFICATE_TYPE = "X.509";
    private static final String TLS_PROTOCOL = "TLS";

    @Value("${document-db.connection-string-template}")
    private String connectionStringTemplate;

    @Value("${document-db.port}")
    private String port;

    @Value("${document-db.db-name}")
    private String dbName;

    @Value("${document-db.host}")
    private String host;

    @Value("${document-db.user}")
    private String user;

    @Value("${document-db.password}")
    private String password;

    @Override
    protected String getDatabaseName() {
        return this.dbName;
    }

    @Override
    protected void configureClientSettings(MongoClientSettings.Builder builder) {
        builder.applyConnectionString(new ConnectionString(getConnectionString()));
        builder.applyToSslSettings(ssl -> ssl.enabled(true).context(createSSLConfiguration()));
    }

    @SneakyThrows
    private SSLContext createSSLConfiguration() {
        log.info("Reading AWS PEM certificate...");
        ClassPathResource cpr = new ClassPathResource(CERT_FILE_PATH);
        String certContent = Files.readString(cpr.getFile().toPath());

        Set<String> allCertificates = Stream.of(certContent
                        .split(END_OF_CERTIFICATE_DELIMITER)).filter(line -> !line.isBlank())
                .map(line -> line + END_OF_CERTIFICATE_DELIMITER)
                .collect(Collectors.toUnmodifiableSet());

        CertificateFactory certificateFactory = CertificateFactory.getInstance(CERTIFICATE_TYPE);
        KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
        keyStore.load(null);

        int certNumber = 1;
        for (String cert : allCertificates) {
            Certificate caCert = certificateFactory.generateCertificate(new ByteArrayInputStream(cert.getBytes()));
            keyStore.setCertificateEntry(String.format("AWS-certificate-%s", certNumber++), caCert);
        }
        TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        trustManagerFactory.init(keyStore);
        SSLContext sslContext = SSLContext.getInstance(TLS_PROTOCOL);
        sslContext.init(null, trustManagerFactory.getTrustManagers(), null);
        return sslContext;
    }

    private String getConnectionString() {
        log.info("Generating connection string...");
        String sanitizedConnectionString = String.format(this.connectionStringTemplate,
                this.user,
                this.password,
                this.host,
                this.port,
                this.getDatabaseName());

        log.info("Generated connection string: {}", sanitizedConnectionString);
        return sanitizedConnectionString;
    }
}