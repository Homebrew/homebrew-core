class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4ba8cc20a19c8d75ebd16cf61e08a82ce4cc8eff0031b52dad1eac49e3ff45dc"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9228dc2810f10451a9e6173b3a8eb200156d5e312e840ec4e917cfcb93816695"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce632d0329eaa9c397a302658b44428bdfe95004c3d17494fa903e9bd213b0c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54868acb906e2dcb424a5f358ebe2f719a0a2ae4e8f1ab6094e8efc84913400"
    sha256 cellar: :any_skip_relocation, sonoma:        "876b609a050475bd0dba9586da15b448dffc9841e05c77322d1888c53f12ec8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628a33c866af25fdceac8083095f32e02d000eba83675c7fe553c9e2be444a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9162a8facce338d131e38f37f648a4ea2abcc1f6d18f550a7ffee41d14b6d4a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionStr=#{version}
      -X main.dateStr=#{Time.now.utc.iso8601}
    ]

    ldflags << "-X main.commitStr=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whosthere --version")
    output = shell_output("#{bin}/whosthere --interface non_existing 2>&1", 1)
    assert_match "no such network interface", output
  end
end
