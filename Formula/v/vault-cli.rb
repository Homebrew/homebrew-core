class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/4.1.4/vault-cli-4.1.4-bin.tar.gz"
  sha256 "f832ab743b3b0947565fbd2cad652ad4a314156e63fd95db4ab619f4cf6aa38c"
  license "Apache-2.0"
  head "https://github.com/apache/jackrabbit-filevault.git", branch: "master"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3610c6dd06f06450d668e4461d1ed15cd68fe0a0e7e0b1e6292f350a33cd207"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system bin/"vlt", "--version"
  end
end
