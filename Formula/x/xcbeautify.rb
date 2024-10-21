class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.14.1.tar.gz"
  sha256 "ecd8843e7beafceafd4c4dd333532dcb835cd7a85de6df2b1bf2015143838cda"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc597f63b3d62f178583c92e1b109b2db4c8ac412d664fe81e270f0e60d23d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a34e57b86d3772077128238392d0630b927b5f819e67896945ae8341d256e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c89c29d2bb110ee9c4f813805d028ee237eff2a6e796b16b3a237d266508e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f08c5fc5c57ba782edeca3afd40c5d479f43cd434db1e2c87ad38ee4a0062b1"
    sha256 cellar: :any_skip_relocation, ventura:       "f9e7f55437698cbe39a3a66e9aed794bd8c8f4275c516fe8c644e16822a867ba"
    sha256                               x86_64_linux:  "d1b78cb2b6799c75faf241bc8606734c534ca86d93d96b5428b77a63f30c4be8"
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
