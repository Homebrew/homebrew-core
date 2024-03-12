class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify.git",
      tag:      "2.0.0",
      revision: "f1eb8fcf41fbb51a7d6a06a76cf06ba5a86270cb"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "737512ccc55eacc6d5fd25fe1298fc266f5fe839012dd7bb5461b89582fd4898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e91b6b769bbe0195e9e079320fc33b214e0b92f782be5b613d2ab33cada0cb91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d9346028de3b03645508667df3504e8679e413df5fefc957dd7f849ee3dca35"
    sha256 cellar: :any_skip_relocation, ventura:       "129b3e581daa6473d6d434ec400feb676feb0e250e826c052723825c180fd06d"
    sha256                               x86_64_linux:  "31f4262ffbf43857cb258c5eaf8ac827036e997cc49a38388b333b8297aefc12"
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
