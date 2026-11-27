class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.76.2.tar.gz"
  sha256 "985f330f7502f8e31ad7afbee3742245250e7a0eef91085ef4ae914dce01f392"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    manifest_sha256 "552a7107ec65ff15fd038e30fca225e669c8b99888cd8079f326f20055e9b73d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2b113d1b4e29748bde6fa7a2f378a61a0535dec4d3b92c961a6404624d67e90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c02d99ed885f437997ec624c1013a4797929916b5bd37b01351f4cd88624d1c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf2c6ed1593651df58db32f49be66cceb10da575199a162acb403a8604bc629b"
    sha256 cellar: :any,                 arm64_linux:       "a07588597c429832eab324cc1819548146b257fdd59eeb402608dd35ae00162b"
    sha256 cellar: :any,                 x86_64_linux:      "629384dc2c4852c81d8c16a3dc5ef4e9e46391484984b4bd95679de9478a5d6a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
