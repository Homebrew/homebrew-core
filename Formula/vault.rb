# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.8.0",
      revision: "82a99f14eb6133f99a975e653d4dac21c17505c7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a6708ba7e83b1b9554a1b4857b74a7fd9661e1728976795aee2aa5474c44cd1"
    sha256 cellar: :any_skip_relocation, big_sur:       "70bd8c59dd9a46e4b6f057476cf64da4f47843a8c114523f4ee92f0cd2f6d635"
    sha256 cellar: :any_skip_relocation, catalina:      "a4e7e3154d186894cd3ca61eabf01f99935c076f9a19d613778d929f5ecec000"
    sha256 cellar: :any_skip_relocation, mojave:        "238c849a19b66f426e35e6db4cdc9dead1535fc526f718f9518a9dbf4105bb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "296b5ec554e21378d65645b832b824b577628d4e3bf6fa4e7fff416b731f7eb0"
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
