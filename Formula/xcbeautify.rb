class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.15.0",
      revision: "65fe6947bbd24d21046609f070bfabf4ee2021dd"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b110ea92c661b41f8033db9968184f583c45545f7eff36f5e2e091ecff52a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "817a7ab51d35820e3b0f8fd1e2f47487c75357847ef2654ef009f3c54e291e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "d94d3ec0de11b29eee428f2080effe92fe73e7fb4449f5f867d9b8ab8aadfb12"
    sha256 cellar: :any_skip_relocation, big_sur:        "7396f5ff493e2dd190e691a5019987eaf74b951b277edcc8897e800ca7961e09"
    sha256 cellar: :any_skip_relocation, catalina:       "838d77acf9366aa20a126a400f66be4bdeec3104aa217c14aaa3b6c67ee98b75"
    sha256                               x86_64_linux:   "479216984e727cb265a4dcc52005b9863f9dc3124b57b15a2b33d1c4a79ab1d3"
  end

  depends_on xcode: ["11.4", :build]

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
