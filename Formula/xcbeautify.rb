class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.9.1",
      revision: "21c64495bb3eb9a46ecc9b5eea056d06383eb17c"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05387bb5adaec4a508dd0b9a0f52210a481900d8be9ce2696a37c67add4f3901" => :big_sur
    sha256 "30230cc7bd735b91ad7eb0e692a349ecc75a0d17109e8cd70502b28c16251916" => :arm64_big_sur
    sha256 "a263117ddff2a44a586920f96249030b176b9d718d9b985e08b7fe6c0e9d4b51" => :catalina
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
