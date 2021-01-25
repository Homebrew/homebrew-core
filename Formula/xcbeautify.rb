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
    sha256 "1b95942893695e6ea3d30c17064939161f6e573243cc92035e930b4e1a39deef" => :big_sur
    sha256 "07f7226da16337b9947871edf3e6112e042d9371872eea692877cd83e3f4e18c" => :arm64_big_sur
    sha256 "5b053728e2ee73f3542cf2b7178af1a5d309970f5374fd1342da93e6dfcb57af" => :catalina
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
