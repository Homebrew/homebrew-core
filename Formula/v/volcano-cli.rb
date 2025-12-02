class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "1839c3959a05292d741e7e26b0dc33e018acfc818f5a690fa8ccaa8fe847a3d2"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d753db4b00bd45c2420176535394cdbfe05aa8cfdf9c7bfe7d5921cf40557e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4b9505f24d04917a6f03276e47411dcd4560629b739f13b201e668028d7452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b2364981682f4eabcda333112dae9209295536994d7223119629e6b09bbaa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d67f7ed570525b1eaad996edbde306095182fa3c85916c3605c6791456cac3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15f70bf49e9dc50d3a1aa0b03fc41f5f37a4c52cef60452501e5560a6b1632f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d068ecba92dbdfeccc8baeadaa348e8543a24d3d34874b67051a7f01e57da4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end
