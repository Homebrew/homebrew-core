class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.13.0",
      revision: "a4cf0dc4437de35fce4860857b64569d092a9b5a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2a661e9fb868ab767d7d27f86e8ff42e39e93d44b994f92970d208f7459623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6337f6e8569b48c355ef041835892cd3bf3cccf424fe126334b8dcab9bb41e73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d15325982de1b160d41167707aca87366ee0d46c08ee78f1e79cc929d83a304c"
    sha256 cellar: :any_skip_relocation, ventura:        "559e4e520dff5044784a9702ad88114882b4b20e54e234872ecc1bc7ef33421c"
    sha256 cellar: :any_skip_relocation, monterey:       "03bcf2dfcb60960643cefa2bcda303893f6ffa18473e1387de66789e204ac671"
    sha256 cellar: :any_skip_relocation, big_sur:        "76864e7f2620eaa6e13aeacc278d16756cd9feadba4232f7cac1fec3a88e8af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2725d3a2a5928ff094d09742a446da13ad8d067bdf91206c056d6687ff470235"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@18" => :build
  depends_on "python@3.11" => :build
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node@18"].opt_libexec/"bin"
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
    ENV["PYTHON"] = "python3.10"
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
