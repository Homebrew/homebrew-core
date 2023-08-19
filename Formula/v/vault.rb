# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https://github.com/hashicorp/vault/pull/22290
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.14.1",
      revision: "bf23fe8636b04d554c0fa35a756c75c2f59026c0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "905eac5b5c5b7da28ac3a6d1e184cc61751368ea23e43a0983c75ad21caf53a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb60b4c8bb3a7e5f10cd5f310396d107e1a7a083310589179e5fc3325ebb310c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd49c92041560ab223a54cdaca1005477f34af264073d4c9aa640e6829bcaa20"
    sha256 cellar: :any_skip_relocation, ventura:        "b10aa980e3039cdfd50a5d359a311ad54ad90729bf36fe178754a0c6184a021e"
    sha256 cellar: :any_skip_relocation, monterey:       "fed4837ea990f13521e1824f415f7e0d54264645539ffa8f0b1174e4d8af844e"
    sha256 cellar: :any_skip_relocation, big_sur:        "750f1b0ad8790ffb46aec5b0ba030b7bb766256f7d3023ee5b1449d665fcdc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f1b2fbd28b62341308643f68bacf7b47f3488acb3bd9b86bd97d2ad3186f82"
  end

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
