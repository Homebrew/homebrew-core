class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.1.0.tar.gz"
  sha256 "f5caac81d22ba70e013a54f153e1dd6a6711a31ff021d373f299922f8460ddb1"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3adb34a4fbc7c4788ed5e45c31357c9e1e640132bafdc8fb735c2ed5c8c9968"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "870cf6e75f0b4b5c23f044809dbd508ca14da7d7de0d3eea0b30b9e607476f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "799183f38cb04b83eab193fdc8995506dcaf06b08dc7e4442121338c16b95d01"
    sha256 cellar: :any_skip_relocation, ventura:       "d11b208c9da76599cada77652b84e403056c5b885394ca3032a7cfcfe83919c0"
    sha256                               x86_64_linux:  "c3fe12f0023ab6ea4fe88882504851b5619fb79bc9fc337e359868245ed7a877"
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
