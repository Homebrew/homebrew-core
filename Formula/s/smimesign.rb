class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b5921dc3f3b446743e130d1ee39ab9ed2e256b001bd52cf410d30a0eb087f54e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b10ee2fac2f1d8b6e518b4442ee3b59d3f42579c83ec1e8c2fd363ad196d4681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c9e2064fefc808679e20024cbb97402c88921c56c9638b04cc76a6c816a13f21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5979116c40aaefd0b504137d670d0cd8e649cca54709a8cb41dfbe390d26762"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8709e59254d883223d8aa3f565054cacce97135da8d7c1b7c941596a75898f4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d103d54144838e83f98e76260c5f3f546729cfa59b52002889ba6716951ba529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2adc095ef7135d81dde128352c105f36affe27882900960e5ea658b1acd2427f"
    sha256 cellar: :any_skip_relocation, sonoma:         "60fb8d6029bb98ff839b6aeeec56c30f94c09da641a593145bf5e9fb6cec9d91"
    sha256 cellar: :any_skip_relocation, ventura:        "bdff73f08ec9eda212fbf271a5d7c131e38e1d9c2263e153db5229dba92c211a"
    sha256 cellar: :any_skip_relocation, monterey:       "b94e7e56d2920ae7038bc1ad9a33adf1ad6cced39c896e9a15515abbc63a423f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9781b5ecad25be5a9ef95fb714caedae7512af4d6a31be300b30c57fd17d1fb9"
    sha256 cellar: :any_skip_relocation, catalina:       "4a8f0b0a87417c22175a7cfa7c25583a3c71170b220d3cbc56b05786baa3227d"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X main.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system bin/"smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity",
      shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
