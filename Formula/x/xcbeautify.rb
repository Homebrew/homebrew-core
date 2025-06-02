class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.28.0.tar.gz"
  sha256 "bf59b8c5fc41f4bb98d603b4915e1ac92e5c1c3ff6eab0369ab18c8819800cc6"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45c28a6ed416061a9863f6fb07dd5ad419213f5f53b5dc05e0235ba673e715d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0627e593edafa19d6a1bb9b0dcde0e8a004c14f2892e3849513881c52d7d4912"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3009d7334bc3f3837c415f0bc081c4022d6b96c3e8a546359172cf263be330ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "39803ea35a27c9e4e875f944aae6e566e612c9068d11de2f6779f3ae97d793a9"
    sha256 cellar: :any_skip_relocation, ventura:       "462eb1a6aa2381674923e2bff1ad1fe024c0fc7f301fcf62a7adceb53f1b2f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9aa22b0109a2d29d0c01297cb6b26159d0743b4936fa8dce3a223b570ceb7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ecf3a32831abb77cb4dcbbced116bc211c13d7d27777c660e9f746886a025a"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
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
