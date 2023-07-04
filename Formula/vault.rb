# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.14.0",
      revision: "13a649f860186dffe3f3a4459814d87191efc321"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4edf1c3bd54202a4176536d76db0793779fb5f8fad555e76e4970baff36c4c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e394b76dc40c306595ab02a2d98b9c0d67521e89d88e3deb3f13bd4e7484ea80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f87285ae004e22a19a29fc7167a33cea07d4871853267dd9faffdf5e1de134b5"
    sha256 cellar: :any_skip_relocation, ventura:        "a9826379d77bbdaacbb65bd4f6f7a8fe0540ddedcd92f59f5c4efae9ee25ae57"
    sha256 cellar: :any_skip_relocation, monterey:       "1a80fb55c147fed65b48576f4d1616ed054e1390ed6aeed220501a26c588afd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9643290c596a171107ec0ec53b6866cf3f9077887a2e0e9de8c4a05e19c2905c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ed7e2021e9f5e361ee6dc2d8765ce4280b9125b4ff8d7272081e10b4877c64"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

  def install
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin" # for npm
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/vault"
  end

  service do
    run [opt_bin/"vault", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/vault.log"
    error_log_path var/"log/vault.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 5
    system bin/"vault", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
    Process.kill("TERM", pid)
  end
end
