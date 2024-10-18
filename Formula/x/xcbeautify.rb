class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.13.0.tar.gz"
  sha256 "89b40e595700b2aa84f0ac92c8bc8da236b613a0a6eca19129f113fae5fc7b58"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370be6448dd65c55664e085c463982e049c93b44fee300ef970973c78a343fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b95c1203a9e234e270d9f26052842328883adcde3ea03097584a2e433218e804"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e43af8291d07e11aaea2a8bc393d4a563cb629b28364a8b15b73a32fa22ecb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc45a26e35dc09d2075c4ec84945e16a314c667d0006f07a43006ed50c48979"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb047be988fcf6c71411cd9a30f84e33fb4751985830faf3e6f8bfce54d0340"
    sha256                               x86_64_linux:  "b7e0f79b1eb890f6b086051f57fb5f4dedc0354bef3655be8afc2d777c58c75d"
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
