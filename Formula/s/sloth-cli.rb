class SlothCli < Formula
  desc "Prometheus SLO generator"
  homepage "https://sloth.dev/"
  url "https://github.com/slok/sloth/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "f1ddad49462cf66652e611f7903ecb0dd86b9fa8f4bc43c7e458e8fa87de854c"
  license "Apache-2.0"
  head "https://github.com/slok/sloth.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "190794921c6b77780f3d1df1d59b8facf7cdb24aa4efb54133fbf001ab5364cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0490372823b434af5147a805555f4ffe2dc9c6ee35b388748babff749e4d70fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dadade0a24902bbbf7eae296a705fce580bfc6e81517e3b3d6404251e613b4d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abce79423a0c2b589184eea712492f143e1864670fb9a183cbf8329399dc0f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10b3daadfc45e9666921b9ccf3441ec4b6adfbe02ec043b3495e2b574ca0514d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0194ac911679b52468285ad282f663908ec62bc823871d2b094b71141c1753"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/slok/sloth/internal/info.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"sloth", ldflags:), "./cmd/sloth"

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/getting-started.yml"

    output = shell_output("#{bin}/sloth validate -i #{test_file} 2>&1")
    assert_match "Validation succeeded", output

    output = shell_output("#{bin}/sloth generate -i #{test_file} 2>&1")
    assert_match "Plugins loaded", output

    assert_match version.to_s, shell_output("#{bin}/sloth version")
  end
end
