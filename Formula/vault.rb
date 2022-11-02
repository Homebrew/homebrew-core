# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.12.1",
      revision: "e34f8a14fb7a88af4640b09f3ddbb5646b946d9c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b0a7a7eba07f26f188c5a10de6bd83611bd6e0baa2893d4204a0c99e0bcb914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2fbbf7859218673df8703e4050abddbb5b3cde0a53f528ba6c05e4e718f92e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a001e1e9fd5d66b53871801a21aebaa1d3cdb1a873b940df5d8b6ce587be2e10"
    sha256 cellar: :any_skip_relocation, monterey:       "98c85fb6380b1924acf01880be668369e94a6ee5db902d5f4164b1977bc5812e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2fc2dbf5a1121d9ae9b442e06d608c8282876baf323406e087d465ffcc332a5"
    sha256 cellar: :any_skip_relocation, catalina:       "2d524bb1d5c007a4e898e6a72dbc07ddef1e0e874477b07a00a12a6c04d0b12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a535d86af01b5b3eb9226a002ab7b11cd792a0b6ba4bf3ad15ec324478e610ca"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node" => :build
  depends_on "python@3.10" => :build
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin" if OS.mac?
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
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
    port = free_port
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = "127.0.0.1:#{port}"
    ENV["VAULT_ADDR"] = "http://127.0.0.1:#{port}"

    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 5
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
