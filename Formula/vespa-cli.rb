class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.148.14.tar.gz"
  sha256 "778a66db8ed641e5bd9cb508e61c80824d9170f11aa51530e38d3a2e74d73616"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9141d538bbe756537d9812540b2ef7c1e29fae79177b397fa3da0d18bec8c11b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2684b915bb803db821522b58926983633b17ac5da50a536cd055b7626c7964a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73009cbb888511ac996172b54b7a3a36cc9527fdcac854c2a33d9fc5533022b2"
    sha256 cellar: :any_skip_relocation, ventura:        "fa980b24812ca6e65b5a2f7eb556c50b74996655054e7688d1a194a487a84654"
    sha256 cellar: :any_skip_relocation, monterey:       "e0fbcddc97144bd3c12c441f93c38df80fdaf494c4cd7394caa2269a6fc7b8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7251c93f3bd04736a6b3f0ae78df7b6055133d8f5676237ecb91e8f06645d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2ae10cf948de8757f4cef9c917670e403e9d7048a3e928c73bab186757ae1a"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
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
