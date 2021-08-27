# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.8.2",
      revision: "aca76f63357041a43b49f3e8c11d67358496959f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10dfd405196881c33a5b20cc78f3f3ac1a5c00f3331e3facd9993bdf12e07d7b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e9c2aa82c3b01b249e13be7823a6dc0fc9cb863542239e2e1be0917ef872b5e"
    sha256 cellar: :any_skip_relocation, catalina:      "027b8dcb2c36e24c52b0b55e569b2ad8e3a422d8d108936b353dfd4a85196c70"
    sha256 cellar: :any_skip_relocation, mojave:        "bb02f3e56b99260044606aa2ef4e649dace21400591c87c28a65560a0d92a11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bb9e88058a23a26fff31072b869c9dde07da3b6fc6458131ab8a24fa44ae32"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  # Cannot build with `node` while upstream depends on node-sass<6
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  # remove in next release
  patch do
    url "https://github.com/hashicorp/vault/commit/b368a675955707db4e940da29a1043871a3781b6.patch?full_index=1"
    sha256 "3595f5a6e3d3f73dfa0db6886f430a0ae5cbcc7f5bd5444c3652bc0c426b26f2"
  end

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
