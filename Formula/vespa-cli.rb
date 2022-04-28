class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.578.64.tar.gz"
  sha256 "578878f37916028333f1b5def3ab4e1802df9c783f54b893ccfb2502313d7335"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c4f23e7aef1e9cdb60500d0347d0bdaad611342590c909e29047ff188fd7d0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce436a9ad4e0a98d4c8633848933e8940365f0e30bcafcf8c529cac179ce7ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "56562ea9388a85ec6ee7382f454bc4a15264e70ba17c6e8799ec2a56dcb908d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "61fb60d9f8ae5e43ba95a48639029922d0293f3dacd0263794dfa6f121ddb8bb"
    sha256 cellar: :any_skip_relocation, catalina:       "3d4b8503b2911d17219b6066476fe39c0914ca902b9676860924d694e633d0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f795346c964e374da619cbe4b91a84c4ffcd19d8f21cb5279cce6d9541811680"
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
