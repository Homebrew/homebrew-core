class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.0.tar.gz"
  sha256 "3b96197098efc79a855f8f5950bc25142f3fe4e561e15f311fc018479f90d5ee"
  license "MIT"
  revision 1
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "079fe5b9f9bc7f06751790e7deba241128bf638a315ac0061a4024e5da2def8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91eed8c305ebe1dca3edf8946657efef481f315932a84bdaf6aa1bd3e534d13c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1ee2ce174564e663ed57ef161598d5707a3edc3ad219d1235e5b75c9d6b50f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "189bd8c5bca42521c18d210ae848b37db7a5515955434dd0480d04ff9677d7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c2750a7b5034492b496c59b9364bc22420447f1041e1e574bfda302824d0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581fb133f3b7c65089cb77730e59fbc79bedd8594d51d3db1f41623c7488b003"
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
