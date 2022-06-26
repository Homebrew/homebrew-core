class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.2.0.tar.gz"
  sha256 "b5921dc3f3b446743e130d1ee39ab9ed2e256b001bd52cf410d30a0eb087f54e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d103d54144838e83f98e76260c5f3f546729cfa59b52002889ba6716951ba529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2adc095ef7135d81dde128352c105f36affe27882900960e5ea658b1acd2427f"
    sha256 cellar: :any_skip_relocation, monterey:       "b94e7e56d2920ae7038bc1ad9a33adf1ad6cced39c896e9a15515abbc63a423f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9781b5ecad25be5a9ef95fb714caedae7512af4d6a31be300b30c57fd17d1fb9"
    sha256 cellar: :any_skip_relocation, catalina:       "4a8f0b0a87417c22175a7cfa7c25583a3c71170b220d3cbc56b05786baa3227d"
    sha256 cellar: :any_skip_relocation, mojave:         "146db9c5113009eb23612bdf240d47a8f539619be6e7d87025c43c5cde8eca82"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.versionString=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity",
      shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
