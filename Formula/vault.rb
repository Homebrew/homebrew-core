# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.11.3",
      revision: "17250b25303c6418c283c95b1d5a9c9f16174fe8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b041e32be82bdf1cedcbaeae21f76d25b1ff0532288823e2d0877b292e8e4d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b08c74bec0537e383e403d74a867db9948a85b94456eef3297e5cfee13522c4"
    sha256 cellar: :any_skip_relocation, monterey:       "b85ca3a99fef928501731bc4f5cf8753028cbcd2cec4700a2a5a1d3c42b82b35"
    sha256 cellar: :any_skip_relocation, big_sur:        "965ee9ae530c41d7a8a683c06415e1a9ee9f6afa00c201074893fed953b0e27d"
    sha256 cellar: :any_skip_relocation, catalina:       "5c888cbd3998a1a4faa3ca25ba1d87f183df7cc75b9fd9b652bed1bce2384842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad3246bf96fe06f0495543a14c8be84751973bdf9797359f66d572058c73708"
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
