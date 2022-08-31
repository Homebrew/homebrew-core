class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.44.22.tar.gz"
  sha256 "0bc3e6d1d867700ee82310958aad4f7a5294686767c09582b4dfac751281b090"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a14e53d76e8f69b428ecb5c4844361b43498cbda21535b7d4f9aab0ecc55b8a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50a89bc3b88ecce8a8e622dc83d15f426037836d5d3e2279e4d13383965c0340"
    sha256 cellar: :any_skip_relocation, monterey:       "fb6fc4f2c87b158983a234b04c991033739133ff6b3d80b8ee4144d6b8af4791"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a8740a60b989534e01d38348d746070f6d758007eb8a5cea7c77e9206b53182"
    sha256 cellar: :any_skip_relocation, catalina:       "4d6ef15a00b5f93bfc9f73ca6314ceec1ae1846067aeec2ffdb59f0ae23a1aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789ce2100d4cd1b97f01f5243fcf588ecfc8ce62a9808e95cad20cc3f8e10ca7"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      (bash_completion/"vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "bash")
      (fish_completion/"vespa.fish").write Utils.safe_popen_read(bin/"vespa", "completion", "fish")
      (zsh_completion/"_vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "zsh")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "vespa version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
