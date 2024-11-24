package studio.ksprateek.service.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;

@Configuration
public class S3Config {

    @Value("${aws.accessKey}")
    private String accessKey;

    @Value("${aws.secretKey}")
    private String secretKey;

    @Value("${aws.region}")
    private String region;

    @Bean
    public S3Client s3Client() {
        Region awsRegion = Region.of(region);
        AwsBasicCredentials awsCredentials = AwsBasicCredentials.create(accessKey, secretKey);
        return S3Client.builder()
                .region(awsRegion)
                .credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
                .build();
    }

    @Bean
    public S3Presigner s3Presigner() {
        Region awsRegion = Region.of(region);
        return S3Presigner.builder()
                .region(awsRegion)
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(accessKey, secretKey)))
                .build();
    }
}