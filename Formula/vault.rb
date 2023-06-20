# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.14.0",
      revision: "13a649f860186dffe3f3a4459814d87191efc321"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f11fc2af37db8f8514cd20662479ee8b98c8b7c6dc3adb91b5fa84e47615c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c31e986d6594c31fa14b3ec2b85daeff7711d3063ecc1655c339ffa831804b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03e645337fccfc1011b456eb8bf7be45b96c10db3f44e37c76c76b915bfbc760"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e5d3496456bf80da4c7b4affeb28e1e43af49c1ca8458a82a459af328f630e"
    sha256 cellar: :any_skip_relocation, monterey:       "7608e1b7730046ad75197c833d9cee437b5c8317df63345e7f582ab3fdeb44e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d46ee8dd1804559a455ec07404a5c3a39d5fcfc5300a1a29afa0f5d6adda549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fad270fc9e7fa2848b9b8e43856b768b8f35434137549a22616ff7404f7482d"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
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
