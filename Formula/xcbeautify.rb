class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.8.1",
      revision: "fd7b0b6972809eead52b9016b383cf6d467e00b0"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71f511194e35bc4e8d75583ad11ca4f8a037b88c5a8490ac54f86faa0d77fea9" => :big_sur
    sha256 "cd33facf2cacba1da0b35945b822b7b9befac05bbcdb11743bc623ef6d250927" => :catalina
    sha256 "c1c8db06d34a1d8cea60edf06143abe926b89715539f4b66d4377d25a93e2e02" => :mojave
  end

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
