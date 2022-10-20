# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.12.0",
      revision: "558abfa75702b5dab4c98e86b802fb9aef43b0eb"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754107244879801180a355fb0aaa6c97aaba23a7a0028df722871b52b70e66f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f241ddf15dc04c13e5bb95afc4541cacaf2835e164a4df55ba2008c9b820adc5"
    sha256 cellar: :any_skip_relocation, monterey:       "f927a816c9e6fb8e6b5768118349e4e8c3048ba68d08d0aa9a0a0ecd7a1b136f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1056e356b49ed890e13ba1fa682ffe06aeeb27d7d997b25d905f8317110a698c"
    sha256 cellar: :any_skip_relocation, catalina:       "ec3c88ad8e9f753266ab8e2e7c008494ba06b4ba64c9bbd1fcd000d9b0dbe1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f58daa33691fed6f373f3d11d4216e18b57ada5e3a3166b2c86371dfadc664c"
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
