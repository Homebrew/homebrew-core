# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  # TODO: Migrate to `python@3.11` in v1.13
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.12.2",
      revision: "415e1fe3118eebd5df6cb60d13defdc01aa17b03"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edd602466cb5dbe92e5802d853bfbe1bbf5defc6501522dc6c50696126e04c54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c622af5f77c7e085ed67e14e707a5b938fa43943d273085be1b78a55fe4e560"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9a85ec8faa1009f2cad1f3fbe3308c08fa3e9da2f9e104aee8a0c24f924fa99"
    sha256 cellar: :any_skip_relocation, ventura:        "91fa68e19b2c80d7f76f68e3b41f97d6a344e866bd342910412e8677ed653a84"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6db09e674138c955e08930647c95ef00ebef3f54b93b7d22ab2d92507a1778"
    sha256 cellar: :any_skip_relocation, big_sur:        "25df1c9f86e8759f6c02186078ae5b6b83262c296efe4b7c7d7d1016246a9703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd10bf75971478cb44dc12960843556a159fc94c68925feeb59c893753a63458"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@18" => :build
  depends_on "python@3.10" => :build # TODO: Migrate to `python@3.11` in v1.13
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node@18"].opt_libexec/"bin"
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
