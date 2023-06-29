# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.13.3",
      revision: "3bedf816cbf851656ae9e6bd65dd4a67a9ddff5e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63bec6e766b0fbc03294e938995448df9ea75b2083a159da9538186f13935515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35bb8da3b81e6fe3db3b63f73c624339a2ff4bc76d7ff3c4f380607847bd8b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba53ba577be9b0f55f1e5b158cf89a216561a564ea1a8405211a89a96f3e619c"
    sha256 cellar: :any_skip_relocation, ventura:        "2365d2344b027e76b585dd4ded3744b2f0f8d60b0584d539e9888d7ea437771a"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f07f1008c3f5e48f46994a752621de472a36f8832b95f1c7301a7bb37cb0ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa239ffedd0cd85e8954e3aa5abea6deb2a74c6e1ee7717531dc7cbbc06da3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec54bd4c7b12750854c90fcb28c33adbc12e357e760d95825fdf39ad4dfdd1a"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build
  depends_on "python@3.11" => :build
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node@18"].opt_libexec/"bin"
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
    ENV["PYTHON"] = "python3.11"
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
