class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.0.tar.gz"
  sha256 "3b96197098efc79a855f8f5950bc25142f3fe4e561e15f311fc018479f90d5ee"
  license "MIT"
  revision 1
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268741b8c03d3a89d536c63f99d23e4f1ca3befbb12af38c6030d74e291868b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b75175e00f954d1132f3085f2794e1e3cfc36a6740e5e8ae50f5ed4a5009ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcbcca352c6158c490032f5640c024c7a9f1aa9ef2e510dd208a010c8d6203e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c176ffadcb073be254c17c7035d47c5eb3b4dd0c688f2d820dcb95ea343168c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "204eab9ae3b7c24128a945a1d0c7fbe893c90a8d33fb84a8d10d7686ed6f60bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53077351efd147027757dbcb7702209f2a76a07720462cb8154c0d3052683d95"
  end

  # needs Swift tools version 6.1.0
  uses_from_macos "swift" => :build, since: :sequoia
  uses_from_macos "libxml2"

  def install
    if OS.mac?
      args = %w[--disable-sandbox]
    else
      libxml2_lib = Formula["libxml2"].opt_lib
      args = %W[
        --static-swift-stdlib
        -Xlinker -L#{libxml2_lib}
      ]
      ENV.prepend_path "LD_LIBRARY_PATH", libxml2_lib
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
