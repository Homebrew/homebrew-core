class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.20.0",
      revision: "2850da9d0e1fa28cfb17709ec66bc87bb07f83eb"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b790b908f5a5d956c830d374fabd5598ca13bd0ef206e5c298b73780dd29de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c91bcd1409af72bd673341982bfa2d8c456a51cede3f6347ce9efca7eda41b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1168f3be1e3759e31941c680cb18a756849804534d1d505c7f151aa1434ed6e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f56ff60fba80b2e3841b54c47d9184a6f61103ec1c30d69d27c896fc0738f369"
    sha256 cellar: :any_skip_relocation, monterey:       "aaac48788c19d6f5e934e167834bec48f7d029ea78f7b9830d140ff3820020a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5a35c28e9b7a5e72a7766f0c54d6281d3d4ed7dcdf4f8ceb77c8051d50e16e8"
    sha256                               x86_64_linux:   "fbc4a2aef5fe553e4873b035460586a873c8cd99602dd00724984be07ea08a12"
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
