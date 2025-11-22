class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.1.tar.gz"
  sha256 "662ea05a051f27c0ce4ffc7e6d815865d49f8821615438f24bde15cff9dc2acc"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7f83b040d8e2535fa0da6b78c2c0ce2d6d03349509e124995ad4ab0bf37e0ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7b0bd63d4d806679f3d17f5a89a9e8758a4ccab2b37a192d807b0515f3317db"
    sha256 cellar: :any,                 arm64_sonoma:  "a5e71b645c4169a390024ed1403a863c4d9d6ad7c8af58ad20b28da57a174825"
    sha256 cellar: :any,                 sonoma:        "92adee013ffd958f54cbd13ccd2b2907f1c4f496dc21d45efb589f3aab9de338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff90317cc75eecbec85f0fddb24b77ee72be10d22d9d77bce988c6eb88e2e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e50342005f69722fe5d2d5cb8ce8283a0e8e94628db1d29f2a3c1ff82d5c30"
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
