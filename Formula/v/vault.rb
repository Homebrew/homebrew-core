# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  # NOTE: Do not bump to v1.15.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/vault/pull/22290
  # https://github.com/hashicorp/vault/pull/22357
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.14.4",
      revision: "ccdd48d1f7b95fc99fd11d67fc1c687576b338de"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26af537dd044826cf7569c9cb4385e53c3de560518f8a521397b18695e9daa2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18ee0a998f38e77c9e5a6bf406fc7326c69caca580efd84b277346344e1afef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79afeebdd21423dd875a11eb314f3c2367da14cc489284836820b97cac63bfc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a4eb54aca81ed892781260cba36dd75c0274c52562ed21e3e6720ebbea75ff5"
    sha256 cellar: :any_skip_relocation, ventura:        "d21db328b2e6cd298c7dd00a9515f676294862fa8a865b1c7c86ea93d8c8e678"
    sha256 cellar: :any_skip_relocation, monterey:       "5521823fa49b37426440fbe642e2013edabba13d841686d759d4d8f699a9c921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4518c13f4613bb7adf425c5eabcd4a4cff94fdfe7def03201ac193f10fa7cb8"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  deprecate! date: "2023-09-27", because: "will change its license to BUSL on the next release"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

  def install
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin" # for npm
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

  def caveats
    <<~EOS
      We will not accept any new Vault releases in homebrew/core (with the BUSL license).
      The next release will change to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 5
    system bin/"vault", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
    Process.kill("TERM", pid)
  end
end
