class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.95.34.tar.gz"
  sha256 "4ed72c3b4c7ff8a3d75d509b4de102de67c0714df60feb3d713a7f824e485842"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee38240ac8fcb5d7020dfc5fdf75ca6ae086abdd19b3c3747f7deafd26a1eec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1b6cdb4a0420cccaceaa9823c5c5f1377246289b4dc5d7ec629a6a0d3715c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9434a38864f6d0db09f7670f9e2e50bd8ee774853dc6dd4ce55e12a4934103b7"
    sha256 cellar: :any_skip_relocation, ventura:        "c045e8861efb8bccef35d11a32bf16640a514d2eb4ff0f3c3702b63fa28c42fd"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef8634d46a5eabbc3d1f797f926c6376672a999a8a098578f85eae82263d981"
    sha256 cellar: :any_skip_relocation, big_sur:        "24626503b973fa61b0925bba9bca17c2afce2bd57919dd08afb3a13f57bff74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ba9ff10d97abf70d6394cb4db5756e6a86260a0a9b407d462c75c272af00d2"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
