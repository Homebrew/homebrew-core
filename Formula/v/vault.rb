# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  # NOTE: Do not bump to v1.15.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/vault/pull/22290
  # https://github.com/hashicorp/vault/pull/22357
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.14.3",
      revision: "56debfa71653e72433345f23cd26276bc90629ce"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3086e3905538354b33c4911f384cfd7bbfd359739a4a8b84d165ae3ac18420c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4880824d6d5cd662a005c7232c789037ecbfb4dcb838981a5237365f5ea5afd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a670d63e3d73729bac35261c9ac536b8aa70374a1c31c6a93bf97a7680722be4"
    sha256 cellar: :any_skip_relocation, ventura:        "9734327f8b5e97c9de79e3f82ab2ff96045528ba95985b564daebc33f28d2769"
    sha256 cellar: :any_skip_relocation, monterey:       "1b64817ab855f410c7da61eb485243706fd36a5acd2ab52164b93d9fa0d36b46"
    sha256 cellar: :any_skip_relocation, big_sur:        "2beca3488ac63d787b47d7c04c3eb3c7432421828f7d818c0b9c2e70a31a5244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34e688c24991ad03cd9e02520652c44e62e6180467ad4303ecf60d0329a6a5d"
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
