# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.9.4",
      revision: "fcbe948b2542a13ee8036ad07dd8ebf8554f56cb"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af8849bfb883c6709303e2f477bbf8118f7a610cb5a0588c6cdbefc77fe78aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5873ce31a62c522bd87473dc52b896c98437fb8dc0c013b9e50de52d6dacc0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "8e3641a34533f592e7766e76236113d47f96343a9eac94159d445560ba029904"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9bbdf0d41dc238b40bb97fcee7d4d7626225d6c0aeb8620654c43fc0a452c4f"
    sha256 cellar: :any_skip_relocation, catalina:       "904390bafeb870c90cc66989e346b85b1ccae9871835fc3de8643e0c75076d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6c56c8c8651fc682b696516da9c612531a3a5aca2752e75a31867c62ce0be8"
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
