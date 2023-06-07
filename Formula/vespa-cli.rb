class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.171.43.tar.gz"
  sha256 "c074314f23df5cf8163f60b1fa2a2f38bd01c9a2e93666df41ffb06d3f82cc48"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98f3d05ffce631c4c1f3eafd70732f08d30faea093d7db7f5ca7b364c68cfc0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d659534845d7351d0020bb4b12e18d650d9d89751d6d6f03e800007e17f211be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbf02f422b5ef5fd310132d18bf6280e45ce622238f826d6d181af27996a3d79"
    sha256 cellar: :any_skip_relocation, ventura:        "5e73781934e3599171472c905931e67074ba60840dc266859d0390a94eae9a6e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf76aa6e2ac50b63e0a3f010a4621fd6a6491f3bafe13a3ac0d966684b5a6677"
    sha256 cellar: :any_skip_relocation, big_sur:        "a48d6fde7ebe5407f299c496c8b1defd6fb9fdf078226b89cfb4ce88984b6c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "014270da5544c75fdd01c8f8ebde44ea11fade17fdb61755cb2c2222052822ef"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Container (document API)", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
