class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.11.0",
      revision: "b14660cc03d96889d2144265fbca471ea0076e40"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6afcab16ef4b9a3420ba4a46f4610500c56bfc7d4e19758c1f3f8833d83a186e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2d5718c40f8afef7434f9973ffea2d3a295be7686060b8f69e03467a8ca09fd"
    sha256 cellar: :any_skip_relocation, monterey:       "a78cfef4c52a33f2c0dc92621622517f3540b8d836ab964f2b66f11bffb68ba4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b680a00564c777c17694c9026180fbd465360e102f9f586bc07df012005624ab"
    sha256 cellar: :any_skip_relocation, catalina:       "6898d7915d127bfd915062051c3ca1f86812b8f8e318af59cbac4ef1b2d7cd53"
  end

  depends_on xcode: ["11.4", :build]

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
