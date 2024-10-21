class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.14.0.tar.gz"
  sha256 "1ad42e4617ac835059bdf220dd08a635f29c97248058fee45faf7fa79809082e"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5d32cc1fa3a550617d433f037d1befe2af85c1924603870c5ccb5133b5faa48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af97aa7a761678d8b9f139f1198e6924dac4dcddbd2e4f61bd24064e1b065ac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04d53ff2e5696e2afb3182c856fa56298578a33b67bd0bbcd09b7853f3b06f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f2e9056d3ff34cc78a748d22aa7b23836a7d4e291890cf9dcc9f9a1d080191"
    sha256 cellar: :any_skip_relocation, ventura:       "06a1d9bf5982ddb00b794d463dd2f82e7758640d3f51fbef080e89eded37fddb"
    sha256                               x86_64_linux:  "33d56a25436681a5ab8c72dd28773e516d78da0f725b61f2ddce470a9d4c75ed"
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
