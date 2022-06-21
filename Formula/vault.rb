# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.11.0",
      revision: "ea296ccf58507b25051bc0597379c467046eb2f1"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465549f58c6ec7fa29628bce3fa6261a4707a9b0c4b27c341314aa18395910d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d052f3bdfeba9edd339ffa33e9cc3f0e67659a0c89da1df215aab1036be30750"
    sha256 cellar: :any_skip_relocation, monterey:       "5043580fc5c44473155274d6c70c4d5b9d692b0234b72b34e8e4d8c9a832eeec"
    sha256 cellar: :any_skip_relocation, big_sur:        "9589ab71d7c85eb3932db628a328ac42e69e80ed86f5a5dc6eedb9246883352e"
    sha256 cellar: :any_skip_relocation, catalina:       "712bf30da625acd464b1fe97252b1ab4214f83b133251db29de3ee7c3643a948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fc660a9b1bd91bee332966e92f9a5d41a1dc95c81525cbde408b6ecca4591b"
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
