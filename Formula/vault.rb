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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f9773d4e2c15dccb20f2a3aa8e0cd9edaa0756ffc8187e08dd8e300de04602a"
    sha256 cellar: :any_skip_relocation, big_sur:       "32cf10246fa1edee79817ed8c41e6136c24dd8562c466fac5af54c94daa44285"
    sha256 cellar: :any_skip_relocation, catalina:      "f91a9a76aca031c55b39cd7d733bbfc9f6ff2cc608e9de2754c70d2197e71be9"
    sha256 cellar: :any_skip_relocation, mojave:        "49002fcd38ec710569cb7272ae9e5ed5088e2dbca3bfea26f8126ce3f9d90113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "354b86d78204aadc0c8c5d05b6deca0e758c31dfb50875cac52633ffe625b318"
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
