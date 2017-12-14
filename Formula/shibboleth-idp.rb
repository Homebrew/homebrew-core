class ShibbolethIdp < Formula
  desc "SAML Identity Provider implementing Single Sign-On functionality"
  homepage "https://www.shibboleth.net/"
  url "https://shibboleth.net/downloads/identity-provider/3.3.2/shibboleth-identity-provider-3.3.2.tar.gz"
  sha256 "ed9fbefd273199d2841d4045b2661671c53825ed3c7d52d38bfe516b39d5fc64"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_rf Dir["bin/*.bat"]

    libexec.install Dir["*"]
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    system "#{libexec}/bin/version.sh"
  end
end
