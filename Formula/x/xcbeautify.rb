class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.2.tar.gz"
  sha256 "03aca657589f0a53bf83c06077014954dd2ff2dc2ed951540ad82cda0a9e8482"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e7cc340c73ffa9979fd88495a996c1384c92883ca472962c9ed7775cfde457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484bccc00e3dc3ca6993b96995277633eb8cd4d31ba9dd53e109959ea0b114eb"
    sha256 cellar: :any,                 arm64_sonoma:  "b7a6086235c4e9fbb15c940fd1fad5886f67837f4edf47a4e44c00b1432b2348"
    sha256 cellar: :any,                 sonoma:        "4fb6b97b6a7b8898c8f461f368cba73cb8afcb5d58a56773866e821d0630defd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e9ef9ae44ef8fef2303234e1a101f15e01457a47c1cfab964f4daadc024b868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5205e299d09bb21e160b5c24c28d1b80538e0c1ecbeb1acc3c50a13c164a3ea"
  end

  # needs Swift tools version 6.1.0
  uses_from_macos "swift" => :build, since: :sequoia
  uses_from_macos "libxml2"

  on_sequoia do
    # Workaround for https://github.com/apple/swift-argument-parser/issues/827
    # Conditional should really be Swift >= 6.2 but not available so using
    # a check on the specific ld version included with Xcode >= 26
    depends_on xcode: :build if DevelopmentTools.ld64_version >= "1221.4"
  end

  def install
    args = if OS.mac?
      %w[--disable-sandbox]
    else
      %w[--static-swift-stdlib -Xswiftc -use-ld=ld]
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
