class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify.git",
      tag:      "2.0.0",
      revision: "f1eb8fcf41fbb51a7d6a06a76cf06ba5a86270cb"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8521e2791a09efafebd382510cb5f2d93ee79eb2dbdc9948736d19a6d2b6f3c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74252429798788eba40b0facf300ad8d21f7138bd63dbc71b7b0452dafdaaebd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0dcc4774893379d0598ba51a49eecba34df6a18344ba91fc26a112d2e8dc4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "23bb53f5da8d3f2bf80c6f82c43f1e14b813526dfeca694da65fc86a405f7ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a4fa2b20919ac03a462e4e565ca11f5445d7c41b93502c1e7192402ebed68f"
    sha256 cellar: :any_skip_relocation, monterey:       "2d417679d5513c90a6126dae00f2fda223b6a151795de7b252afa2b5ac06ec2b"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
