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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152353389c862269a421ea7d5b8529dcbe37228eb7ea6ab39dd1813b03f45852"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8bf80a56b92bf7a720baf9e977db5268f6b2f62944445846ac957954feb1f93"
    sha256 cellar: :any_skip_relocation, monterey:       "748162441ee47a1f7e9b4fb79bf6b5e4c61145c0c1bb6688b6930f7f5cb642e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa7531271441084ea7dbccc19d76680de3614e71ff3fbac569f4eadcf5be9364"
    sha256 cellar: :any_skip_relocation, catalina:       "191e2418eb1063cad138b1ecbf2696f910582a37c0c721942216e6c7f194dc5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a40b2327ff34d7e76975377c1e91ce1aed6d84cb32ce4708228df57b7404c317"
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
