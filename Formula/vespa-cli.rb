class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.565.113.tar.gz"
  sha256 "cd1e03ea52254f17bafef0cadd9b248a4714e847cb51451768a31d969d5051be"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15a3bfc6df79cef0aaa1614eeb5d940c9c7cfbf628e9402444370c0e67276c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3622cfc18bc38a5b317f7e1bd674aa23be94ff33b97ef1bd2f6bb2c11c2f37a0"
    sha256 cellar: :any_skip_relocation, monterey:       "3fbab0bc398cfaf4506e4b887ae49f9f3ad99cd5012195572fd5c70780e5a371"
    sha256 cellar: :any_skip_relocation, big_sur:        "94e5b171aa1cc9145dc63a520a39915c22ea68f76d44117661e8267ea40d647e"
    sha256 cellar: :any_skip_relocation, catalina:       "c1688569d718d7a4b90781cfd5002c36b9058d55dd3794a081838a02c451d047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26117f430e0547af9e0b55bcc8e93ee878e2fec6aafa021a0af31fb4d45b7667"
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
