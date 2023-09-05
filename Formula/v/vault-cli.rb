class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.7.0/vault-cli-3.7.0-bin.tar.gz"
  sha256 "110cb6619ec6b1cab3c0d2c3e2a945ab12bd2154a7658621d15e9355e2905a99"
  license "Apache-2.0"
  head "https://github.com/apache/jackrabbit-filevault.git", branch: "master"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde05d75b070ebd23dc721b1e772a743b33383c6889676868eae51dbc5314b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde05d75b070ebd23dc721b1e772a743b33383c6889676868eae51dbc5314b32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cde05d75b070ebd23dc721b1e772a743b33383c6889676868eae51dbc5314b32"
    sha256 cellar: :any_skip_relocation, ventura:        "cde05d75b070ebd23dc721b1e772a743b33383c6889676868eae51dbc5314b32"
    sha256 cellar: :any_skip_relocation, monterey:       "cde05d75b070ebd23dc721b1e772a743b33383c6889676868eae51dbc5314b32"
    sha256 cellar: :any_skip_relocation, big_sur:        "cde05d75b070ebd23dc721b1e772a743b33383c6889676868eae51dbc5314b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7d39d5b57316e6a97a7440b27df46143b0559d83f4d55f088c4980d7476e7f"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system "#{bin}/vlt", "--version"
  end
end
