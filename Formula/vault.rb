# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.10.0",
      revision: "7738ec5d0d6f5bf94a809ee0f6ff0142cfa525a6"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f17a2b741153a21b5ed48cef686bcb321309fdddf8c4d8a46b8d31db3a79458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "276c96df41902e10ae0e94b2a812320b20b8cd8fda0bdd2cebb204127aa6e431"
    sha256 cellar: :any_skip_relocation, monterey:       "a61c2227fc261b23a187719f22c7462190840681ab67ab266975c1a0de28aafb"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f97ccfaea109b586047412a2aa591106dc49b31b37eb8269e216b9fb74d3ca"
    sha256 cellar: :any_skip_relocation, catalina:       "10ac8dd0117e4aaeacdd5b65048d0438a4f5985e90a4d975325914ca98b7613d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89fb32fb7e7e5d3e8a73ec6165a8335e1ffff9fc0e01e8d2ba95752b3596fe9"
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
