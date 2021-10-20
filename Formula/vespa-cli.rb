class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.481.18.tar.gz"
  sha256 "a0f1ed8689286a1f47f069b73bc6bb201695b412d016f4d49488abc5d2c9521c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "87d6371d38a3ee08ed7d1e0ba081598fd7c65e7fa5a3bc7312deae9ddb314ac5"
    sha256 cellar: :any_skip_relocation, big_sur:       "158d96fee4eb387366d59f96b87c6cdf7c157b6ce1642abebd7d85be7f8d7e4e"
    sha256 cellar: :any_skip_relocation, catalina:      "8471f4f31e1a5e29967687e677936f8d99fbb246f3c60c1b16149dcdec91574b"
    sha256 cellar: :any_skip_relocation, mojave:        "8cb68d98fa78aa8c2ebb329e001d3f19d9dcc8d172611d44e041d2ee6967a237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187a5c444f0ac1075603870f880144a0355dba94a18cc66767de85d63683d359"
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
