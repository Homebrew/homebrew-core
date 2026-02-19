class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.4.tar.gz"
  sha256 "7d4332563e43335c9ecad819ff1d8033b052020cb73729cdeb7f25165f6cf9f4"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef3c331c4ca486199100920e7ebb678493ca783b1fb5611b91e2d2b35d18473c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7b1afe773e113e60388b7a66095d53d0d1f1ad15abbaeed1a8862406224e79"
    sha256 cellar: :any,                 arm64_sonoma:  "6d12e847843081ce1b1fea4353ac4139b4949c73c2895a6a6152ade00e352514"
    sha256 cellar: :any,                 sonoma:        "aebfb0d907b480a352adde2c8bd36df26a53d09f10cb65558680486cd9ec6235"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5c468e2572675f5f18ef0c1dd1e9a977f7d02c320503081a79650c2f7377935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0114d59c8ccf060f943136d40d642afe80070ce11a1300086f600a2bd96dda0"
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
