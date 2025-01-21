class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.19.0.tar.gz"
  sha256 "cc6147c51c9ecb844d106874135818c5ac665454f773035bb4ee9415dda2f594"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2fcacaf0a16472d7ed115937171f47472fcc8ca7a6394e1d53c66227b5858e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e98daee69487849c3cd8a825063e77abd48e29211ac438acac1232c30d514f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a34cfa881b276f8775750ff605c976be33a26310285f384555827704a5f9ca14"
    sha256 cellar: :any_skip_relocation, sonoma:        "723d1ffe6bae8ed764c840e6c6d03a1dac05e98f0dbab77ee2967d46c26b7940"
    sha256 cellar: :any_skip_relocation, ventura:       "a3f49ab16f9a89f51c5a360a9e361756c4ca7a424339b9f81d66f04123b1f53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b656bf4300abbe6a9b644f147e609e25a0f443205781b6c164abb4075e7f629"
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
