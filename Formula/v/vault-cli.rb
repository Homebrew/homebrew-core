class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/4.3.0/vault-cli-4.3.0-bin.tar.gz"
  sha256 "86aabecc10c28b8df19e842f8a3133ceb724e39682898e14cd3094007f99c942"
  license "Apache-2.0"
  head "https://github.com/apache/jackrabbit-filevault.git", branch: "master"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    manifest_sha256 "9fa9d362237e5e3bb1fbd5d5e99b98947e7fcc061f2dc5914282cb1d658236c3"
    sha256 cellar: :any_skip_relocation, all: "855f9becbeb52457ab270afff1d9aa1628be6be0dc712ecac3042c3b97db1948"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    # Remove windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: dep("openjdk").opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system bin/"vlt", "--version"
  end
end
