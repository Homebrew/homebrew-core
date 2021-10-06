# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.8.4",
      revision: "925bc650ad1d997e84fbb832f302a6bfe0105bbb"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "829eadb0afda3d5fb5762315e7ee941366ca465773d63980324821282186e267"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c97425d8f53efe6ee7dd14d4caf2c74287bf96847309d433218f7a6c4c27a7a"
    sha256 cellar: :any_skip_relocation, catalina:      "4f8387c17c9f500fd87675fb17e3bdfbc2ce46593b912d708dab7534d49019a7"
    sha256 cellar: :any_skip_relocation, mojave:        "63c3d5cfbc2357d4fef545f012fa3ff90a64f67a35799a7029797b96c266abcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7c6f4d80754e46760aa4d4044551803dc2c1561d148f6e397fa6ffb8e74423"
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
