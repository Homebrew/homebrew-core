# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.9.2",
      revision: "f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e258e470f80eb08723c5eb5e5807395434a25bc217d420c2f4e4f877e97733"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3fc196b9124b146ef5076037e4dd2b71acd70709f03dd454cef730f3fbb3a8c"
    sha256 cellar: :any_skip_relocation, monterey:       "065f6a2230ebd1b7e514d0f6faf6396ab53258bda6810dc2ebd692b8fbf17653"
    sha256 cellar: :any_skip_relocation, big_sur:        "430904a51b61c9c717e86ab10c510492e6e967f3c23f9b000b1a043abc098c6d"
    sha256 cellar: :any_skip_relocation, catalina:       "1e49a96fb45f0acce29ba1e16e52b5dc14a408a26e8f99a11257798f41842aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9607d454e58c2aab18ae2c75fb9d91dc5bf20a1122a6f5f24aa5952688bfe09"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  # Cannot build with `node` while upstream depends on node-sass<6
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
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
