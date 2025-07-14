class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.29.0.tar.gz"
  sha256 "68d759d6a44de55a8e16ffcd8347f4479c633a0a90f6f878b4be6a5136b41dd5"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5451e645f57e9f540e0a0957013c14518173fc047868635b773a50e414e0940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0a3d33d7ec41154b8d1c9c1870760d5ca50cbc051ad9cf764da61dcd974f38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40081971786492ae2dbffbc6595efec2a7cb844af96e3852945aed83da466cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "54be601eb8851f9c8f9bd0aa998f576e36fe9d9f41e61293da43694d2e404b35"
    sha256 cellar: :any_skip_relocation, ventura:       "c1451f4732c670032f3e256daf518d4ff35084e260309716da82f9d17c7e6903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0a22445fad3e429d3886d662d1dab83e0a706e502bd18cedee9a45dc31429c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3df8d22d5b11ffec8f87a1081d74a63f6730438f2a066ae66fbd32c1e2027ac"
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
