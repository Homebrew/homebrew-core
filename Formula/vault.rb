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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ced42a44f42243e4a6a131cec0a6eff81787f75a9abe2def51c360eb20e3a22"
    sha256 cellar: :any_skip_relocation, big_sur:       "a988b0c45103f3484b4b8c127e6ea14ca62d5bbb674eff7ab045d7c648a32353"
    sha256 cellar: :any_skip_relocation, catalina:      "31822a3eb3e2778bae0df37542646bb88704b03c90951c20c381b250e626a3db"
    sha256 cellar: :any_skip_relocation, mojave:        "8bb899e7352119bc0609567204d0f2c5444df0dab68ff783cd90a4de0b8e329a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e795726b9c4dbcbb5b1783a358178a037e688cf48d6cc69e2ea139187e95f0"
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
