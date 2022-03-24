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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd093e6cc7f7c4185282a92d0844c0aa8527b3fcbff8ad9dda0f1f1259e19a00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9f940a6c66cf751145ac8f35918653c2c76e1dc100bdd94f12a7a52e1842787"
    sha256 cellar: :any_skip_relocation, monterey:       "0e71de8e8d51257df8d55545d6c9b602f08cbc8b95e8f7c0b5eed176a0b7ea4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccaa1a533d4a805f2e53ad5fc392a36e9814cafe5691ae921e2c421fd853fdd2"
    sha256 cellar: :any_skip_relocation, catalina:       "4200322afc0841b0a4e7c8b789f6913424a90e1c8e9952595671aac6445a8c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c1a950343a5130c50d557804f6340ff7eec1c1cd49831f716bc81ff45127bd"
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
