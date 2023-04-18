class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.13.1",
      revision: "4472e4a3fbcc984b7e3dc48f5a8283f3efe6f282"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baba4a8b5325142f7ef5833e4cf074c2d81681c4c810b9f86fcaa582d7369867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739c1eeedb7f95e9dc1391fce3b2ae65e7eae0c9c7e94c8a9692bb823a36cfa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abaf2ad9b4bc134758c845520996d97e1b10c85b56f52955b515250de496970b"
    sha256 cellar: :any_skip_relocation, ventura:        "7a1ac30045fd5c8f6ed881e57b416a6e0da2e59e71301fb3b44733ef3574837e"
    sha256 cellar: :any_skip_relocation, monterey:       "1c8372e3021e297c231085f1ebb06446db1ac0162e7c2125ab44c8e985905fa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b285f3284af554be971ef4f7d45af791ebd0423bfeacb3be9bab0d85c56cb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de2417ffe5cb7a0223f929d8778baec078e864350e93fb0b982c00f5a251b2e"
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
    ENV["PYTHON"] = "python3.11"
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
