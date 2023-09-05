class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.218.31.tar.gz"
  sha256 "758e99339afae431ff3d60e766b69ae652c880d5319d4a6e75ef2358682adf7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02dd6eae1ee39033563919c234d08825dae942d66f0b99f72432073919436505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33cdc3c66d75ba5ce85059939ff44a1f95610684c5b62e42d5b044752eb35a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "467143f9b904e2b9d89ea221b5d357bbeb39a534a769eb543d67a6ced33ecb3e"
    sha256 cellar: :any_skip_relocation, ventura:        "d443ef4516101cc6bb52e5d8447dcd2dc361e35b7587abf3d09c3b3051e998c1"
    sha256 cellar: :any_skip_relocation, monterey:       "f03c92ff25ad9b178f7ca1a0001b10124c95aa89177c6e925d91bc303e945911"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3e5340f38809d3a7d3cfa259a6b94c94748f9e95cbe170de76fd0d76c339167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f211c9844529f2bdcec1739421a9f3614c9a7a4c268718b5a53dcc260990d27"
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
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
