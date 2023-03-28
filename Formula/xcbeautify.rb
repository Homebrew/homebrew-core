class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.19.0",
      revision: "e3bc4e04618efa7aaf8fac4727f7fe7ffd951e08"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "099fcf0dee67ef581cea24fdd71373de2df7afc242777e6b708ecaa76bee3943"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14111fef39cdb6e9fd0b78694ce0bbdba058b506f49b1f946a12693b0314a540"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fae7f5b74af43fcfc199a0c35551b0a6f5a73f5cffeac3b1312cc05ab9ee2ec3"
    sha256 cellar: :any_skip_relocation, ventura:        "e703db7316c728405ffcb575e06ab12207c6f0e8d3f89df8f5ea7d889bbea52e"
    sha256 cellar: :any_skip_relocation, monterey:       "087766fc80f24f4f7be279797c6f6488616965cf69ea0969ef1d407d462fa053"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c5506e47ef58a1706c8e5b5e9eb75e05cf57c4868c497faa3e86e3403dc004"
    sha256                               x86_64_linux:   "b89fe34cbad59b1dfb8d70a1baf31e153302cd4c3e730c871d368d4068082c7b"
  end

  depends_on xcode: ["11.4", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
