# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.9.1",
      revision: "3d69cbbd35a8e7a51bd036849f39a7fd0eb9c2ca"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15d1d63cc1e6028d4ea4284517354c17dad4348b91b99c468311ac86ac682796"
    sha256 cellar: :any_skip_relocation, big_sur:       "61f7b7a0042e66afc38be2bb3a892c93674e38d6b33de8e4f88f7b48c4bfdfbe"
    sha256 cellar: :any_skip_relocation, catalina:      "2316c2d94d761c6928e67b28c122fb9175943f965cb389d2735edcb61bc3e904"
    sha256 cellar: :any_skip_relocation, mojave:        "38c70bfa12f622a9a7ad27d8b63b50b56dad4729b4b67a88109d7941d84f3982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade90a215435e4fb81baca40756f4b9c9edb02f3f31365340956e12278956356"
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
