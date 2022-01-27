# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.9.3",
      revision: "7dbdd57243a0d8d9d9e07cd01eb657369f8e1b8a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "074d1c491defc2e8c744fd9745ada748d371d2ed1d6aa0ca42689d954f4e7543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4224b8dcaf6ce5f2479ea3f3ca05f34b0a69a5da99c7f023eccaee9ca144143a"
    sha256 cellar: :any_skip_relocation, monterey:       "5fa336a299ea46a7075710391aa229d18f7e20c6a75750999accef6f0e310513"
    sha256 cellar: :any_skip_relocation, big_sur:        "878f2c3955024d712d508853d9ca1650b8643e912de0913b25463087c8979ebd"
    sha256 cellar: :any_skip_relocation, catalina:       "b1c4c6d78588842694509e20c87590aae95d095d9bced7d8a7262bb8ce5446e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe948a9927154ed30c51758969a1a40a1e73c0477db0fb538100379a6941728"
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
