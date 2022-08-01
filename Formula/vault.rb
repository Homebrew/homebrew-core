# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.11.1",
      revision: "0f634755745f4adf62ec0723a0b93d6dce5bc33e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe26f67d544de4e8bcb79247e2c1178980e4b295ba73d92e34406edf6a41b132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb2f32edaa2fd7d64382a14946d21bc07261e610ab139438d65fe073d8b78aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "fba6ec4228c141af664c3fd1bbfd602b283d59ea9fd2ffc33210ecc1024849e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "25e6cdf50d70dc1a13d7203f7fc4eb65d341fa5c9efb181ef3a909d89179d54f"
    sha256 cellar: :any_skip_relocation, catalina:       "b74872058e07b2b93e93753a5460f26e1297b86096a994eb266a705a6ad20ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88251a148e9d747aea3c56a8e5232fd37b094694d13e3ea0f56c0c3271bbe35"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node" => :build
  depends_on "python@3.10" => :build
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin" if OS.mac?
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
