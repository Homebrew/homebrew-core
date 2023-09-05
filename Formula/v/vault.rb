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
      tag:      "v1.14.2",
      revision: "16a7033a0686eca50ee650880d5c55438d274489"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c14d2de5877cadeb0651e4ca1fa5ad1cd8ce9ed51b7b9599fdc8728f4ced522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e634741eed869a71f30667c4019eb686cdf05011fdc3d16f12311495a318b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "162bd36dc50835bac4a7ca2c99acfc92cd36cc2550ef41dd34a7d64efda276ef"
    sha256 cellar: :any_skip_relocation, ventura:        "1ff7e2a9b1df4e95fe1ee592021f5bd402d6afb0b0ce78066b7157d1fe9b23ae"
    sha256 cellar: :any_skip_relocation, monterey:       "dcb24b87fee9e6dfe4de0bb748caebbd08e28c25581c7c5472bada2989da7d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "af1b754b97c9dd066e69e272a0bdf05469b77c4c132d01e9b177bc705e0c3091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb7eb901ae02bf3193a78738a9006730d7dd814924d977f22a457d3a70a3f88"
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
