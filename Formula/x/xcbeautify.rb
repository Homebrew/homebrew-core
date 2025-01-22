class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.22.0.tar.gz"
  sha256 "3108b2cbd273bbb82ad41c5e02ede8129b073c0e75736b582c75a5098ac42dc7"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5802b0b188d06c73c12bf61fe861dbbec0957c7874030f39b0f6b1fa479f8beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8740293c464290297af9d10a802cfe2aff63ad329e0da4ce58492bad5cfec3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c46aea79a5437537bdf569c42cbf896b8db8315137ef0777ecc7c5f34fe84d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "073a94011435456cc49bface5f6581ee22a54d301f2d0f5f615f197f7b0b98de"
    sha256 cellar: :any_skip_relocation, ventura:       "b89dbb1d98dadfad17510e9e781d1701973f0152ef7d0f57acc1fa5d9eb192ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71c4b353451a97ce447fcfa2092331ed099f809aa052cd99dfd0a79b43f7621"
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
