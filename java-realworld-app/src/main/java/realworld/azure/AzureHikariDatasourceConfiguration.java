package realworld.azure;

import com.zaxxer.hikari.HikariDataSource;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

@Configuration
@ConditionalOnProperty("IDENTITY_HEADER")
public class AzureHikariDatasourceConfiguration {
  private static final Logger LOGGER = LoggerFactory.getLogger(AzureHikariDatasourceConfiguration.class);

  @SuppressWarnings("unchecked")
  private static <T> T createDataSource(DataSourceProperties properties, Class<? extends DataSource> type) {
    return (T) properties.initializeDataSourceBuilder().type(type).build();
  }

  @Bean
  @ConfigurationProperties(prefix = "spring.datasource.hikari")
  public HikariDataSource dataSource(DataSourceProperties properties) {
    Class<? extends HikariDataSource> dataSourceClass = HikariDataSource.class;
    if (properties.getUrl() != null && properties.getUrl().contains("postgresql")
        && !StringUtils.hasLength(properties.getPassword())) {
      LOGGER.info("Using AzureHikariDataSource for managed identiy");
      dataSourceClass = AzureHikariDataSource.class;
    }

    HikariDataSource dataSource = createDataSource(properties, dataSourceClass);
    if (StringUtils.hasText(properties.getName())) {
      dataSource.setPoolName(properties.getName());
    }
    return dataSource;
  }
}
