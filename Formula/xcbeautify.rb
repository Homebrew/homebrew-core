class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      :tag      => "0.4.3",
      :revision => "d7363b1990200996040b5aa79106536aa8b132d3"
  head "https://github.com/thii/xcbeautify.git"
  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"xcodebuild.log").write "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      shell_output("cat xcodebuild.log | #{bin}/xcbeautify").chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
