class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "1.0.0",
      revision: "a996cc125e45afb9f2d77cacc5710f3595bcdd07"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8f49160c9c1df0f01ebc1a4530289fb0b4d69093bf6a1a501f5647844c1437b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bacf88c0dd3a4132e5cf01dc9af94d69678e8adc9faadc0b55eca53dfeb4edd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a46df2ced30543c8ec0fb7ea53a1ffd45f69db7ed9b59a5ca5fbc6885606f9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "400ad7359e6c260156e1982dc2d0227034c3294b95db899555c2c3375651417c"
    sha256 cellar: :any_skip_relocation, ventura:        "2d7d8323275c3d5f808434c84808a59c4d8eabb128053f05630f298b592d5bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "4688cfc59364db9efa881f2cb4c99f2304149c0f69e2bc4164cbae5d525ca7ed"
    sha256                               x86_64_linux:   "4f4ed4b6e2367b3ac361e4916186778de7aef1b6a2dd772e4609437f05ec3f3f"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

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
