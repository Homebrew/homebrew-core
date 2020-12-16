class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.8.1",
      revision: "fd7b0b6972809eead52b9016b383cf6d467e00b0"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git"

  depends_on xcode: ["10.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
