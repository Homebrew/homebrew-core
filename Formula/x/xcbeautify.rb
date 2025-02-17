class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.25.1.tar.gz"
  sha256 "c7a9d999dfa27184601b6df817a5bfc9acaa0b0b7b93886126ff281862548efb"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9e6f6795b453bf800fde0a4bd362d0bca5411b4cd309409924d7ba2f1fcd4b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9c6645a044a35d4de8f9f12b107d99abb6a8c59da0f5db5bf7b54bbf4a0f014"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78557a3c74297b17425314415f4fff43f6210a4957d4a33cbd7ed09946210ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b446340ce6d4431cfb5a999445c87855fd399535b5a93d7e145ff984e01d4cdf"
    sha256 cellar: :any_skip_relocation, ventura:       "2de382a322c1b10f0548c312e464f9334aa6c0266feebccfc9b43e8216155ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27edd3f98dbbbd5999c8eaab1302be6e7ffe58efebf94070051acec20e61129a"
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
