class WatchSim < Formula
  desc "Command-line WatchKit application launcher"
  homepage "https://github.com/alloy/watch-sim"
  url "https://github.com/alloy/watch-sim/archive/refs/tags/1.0.0.tar.gz"
  sha256 "138616472e980276999fee47072a24501ea53ce3f7095a3de940e683341b7cba"
  license "MIT"
  head "https://github.com/alloy/watch-sim.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cf8bd59511daa7a7bf5bbe7d8a1c50503df5ba0bdc0047df7de6736ccc7bbd3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ef6e2048bbcb961e59e3e5f25602fd685222f49c4cad51da8bbb12bc3de3d7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2551be702d19489b5bc7224b2312c132df7a5090fda12c5c0e305b4982e828b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0bfc458d4d6388c5a56247f39d543f46a28ec27031a2c28da38d29a729ff74d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5ce9e4c33120183ab5666c3a33b4c98550d4dbfa2da0f8aa8c0b265ce6e985e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a615d042db08236fe150fc21ecc8ac12979007f851b90aa85faa4f7ba75474b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f68ab095c38433474978faed7b16e61cea41fae11d285828ae2c88727f8dd0e"
    sha256 cellar: :any_skip_relocation, ventura:        "0acbe748d776213a08f8ebbd082a12649edc1f848d7db02133df2edb36974376"
    sha256 cellar: :any_skip_relocation, monterey:       "6b1c014eff643254d48164c4aa1c1289d0bb4f30879f267982c3871f65437cb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dc3e4f2872aeb25d3d4bcb22aac1012730b468543d351d0114498d8211b7f0c"
    sha256 cellar: :any_skip_relocation, catalina:       "bee9797e2c3a52b7dea9b6c5158bb78485b7ee10af530f84d81f31e20babf894"
  end

  depends_on :macos
  depends_on xcode: "6.2"

  def install
    system "make"
    bin.install "watch-sim"
  end

  test do
    assert_match(/Usage: watch-sim/,
                 shell_output("#{bin}/watch-sim 2>&1", 1))
  end
end
