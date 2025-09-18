class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.30.1.tar.gz"
  sha256 "6cc64ef9167a02b1c097f995941e93d756e27c570006ad6f9e9c83db83ed2603"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32b0d648f4c22e916db671283fc156f9e5c05e95c17c10c7a3ae54e18a4e03a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45aa6aae0d7a48a05719aa0bd20a3d49d2eb3b602763dbe7fdb20777c57f998e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "438d03f0c727ad6afdb8364d56abc2e2d61b17b4bca9d2fecba9b676618f9e9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0b0a8bd11267bec6d150639bdd0a954c663d784f1c1de63e8297a126c01d266"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b103beb64a4a1c716f761ac978496184e220ede127efc1f44f8084cf62d9b63"
    sha256 cellar: :any_skip_relocation, ventura:       "d715ace6defcf2422803a14d01623ea3805978a611ba5cc0c9c17d5baaf01ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dddc7750570072cb5609cc9bf22e88b5867e71633a2fe70aaf347124e545d532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d81bcec58668fba3b890772640a7d26f456a093379755b548a41bc3e9772f079"
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
    generate_completions_from_executable(bin/"xcbeautify", "--generate-completion-script")
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
