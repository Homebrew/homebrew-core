# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.11.4",
      revision: "b47a9e72942719f217f7750df18be36ec21dfc0e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ba293887a946efb82796307e32b68c755e9f46372405a3c09ce638368c89bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae1379cfe9e27825f237c253d6bae76d752685b46aab313aa7e20d987023b42b"
    sha256 cellar: :any_skip_relocation, monterey:       "0d0b0519de19c34b2e38c6e8fe05d0723df0664b2e31019631ed3a98bed45fcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8acab5c16fa3d555625963976f13ce57412af4bf71fae0e6184ef734b204ed19"
    sha256 cellar: :any_skip_relocation, catalina:       "f9c51c292a85f52618453445dea925c9f86d835f9958e61d70645cf2293272d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8493da41d5a645a9b23e9f6f68c7d7b0b9fe9aeb00a29cb7f9c62d79daec68c2"
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
