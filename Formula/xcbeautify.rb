class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.16.0",
      revision: "b578117619ffed44fb879b29e4e9a481143b0b1b"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6bec8019161280b434f9e76d5ba08742d1d0b8dc236408d01554af2d327133a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f133729b9d2a40b3d4f162420fcae8425789905cc30ce4f81416ab792cc96f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58d1037d0a4a6df88b5549973635d02e2adc4abbc2fef7cfc5302be5db7289cc"
    sha256 cellar: :any_skip_relocation, ventura:        "901bea9761c40f4550b64978c7f0cfd92c1a6fbc55c4e155b1acbd400d649789"
    sha256 cellar: :any_skip_relocation, monterey:       "7e51ded6a1619f1e00032df16da653aa228790a93b14498a2b20885cd158294d"
    sha256 cellar: :any_skip_relocation, big_sur:        "99b802ced5e8f9c16f2983315606f4512d3cf62b9cd43ba51079701edd36547f"
    sha256 cellar: :any_skip_relocation, catalina:       "4c348994041017c4f18d3a5e39981204be679b756850b3bdd4e325aa3e71d711"
    sha256                               x86_64_linux:   "2013cb7179eb9f8f5706f291b731d8fc5d5f1249d142ac492261efaeab0daec7"
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
