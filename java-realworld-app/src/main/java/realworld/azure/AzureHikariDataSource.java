package realworld.azure;

import com.azure.core.credential.AccessToken;
import com.azure.core.credential.TokenCredential;
import com.azure.core.credential.TokenRequestContext;
import com.azure.identity.ManagedIdentityCredentialBuilder;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class AzureHikariDataSource extends HikariDataSource {
    public static final TokenRequestContext TOKEN_CONTEXT =
      new TokenRequestContext().addScopes("https://ossrdbms-aad.database.windows.net");
  
    private TokenCredential managedIdentityCredential = new ManagedIdentityCredentialBuilder()
      .clientId(System.getenv("IDENTITY_CLIENT_ID")).build();
    private AccessToken token;
  
    public AzureHikariDataSource() {
        super();
    }

    public AzureHikariDataSource(HikariConfig configuration) {
        super(configuration);
    }
  
    @Override
    public String getPassword() {
      if (token == null || token.isExpired()) {
        token = managedIdentityCredential.getToken(TOKEN_CONTEXT).block();
      }
      return token.getToken();
    }
  
    @Override
    public void setPassword(String password) {
      // ignore password
    }
  }