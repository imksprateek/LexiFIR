package studio.ksprateek.service.service.document;

import java.io.InputStream;

public record S3ObjectInputStreamWrapper(InputStream inputStream, String eTag) {
}
