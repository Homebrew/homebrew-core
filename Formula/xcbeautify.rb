class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.9.0",
      revision: "105251c21b9b70d4f9c31001d6375df858081ba7"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71f511194e35bc4e8d75583ad11ca4f8a037b88c5a8490ac54f86faa0d77fea9" => :big_sur
    sha256 "cd33facf2cacba1da0b35945b822b7b9befac05bbcdb11743bc623ef6d250927" => :catalina
    sha256 "c1c8db06d34a1d8cea60edf06143abe926b89715539f4b66d4377d25a93e2e02" => :mojave
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
