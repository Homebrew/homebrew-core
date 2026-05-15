class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.2.1.tar.gz"
  sha256 "7575dcb90e4650f8d8f66b92ca2f3eaa5ad9feddda7bf3c63aeb0edca199aa80"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d10b6b29942408802a3f7c141c8245b310054331c39be16f027f93867ad005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1094ef28d3e6f734cc58b43201a7112218b2518ed5b47b0c4e3242071a90742"
    sha256 cellar: :any,                 arm64_sonoma:  "f65b81e0e1d354fc026fda8e4006579b99e764a5bee9cdb20343a432c902f84a"
    sha256 cellar: :any,                 sonoma:        "da329e9b36ffc742e9dcba04f9bc2d2dcb05e41ecb9d902b5ab016145a46ac2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0699fc7ed411b8e6875d2273dd230b83947a10f38471e59ff953a57283cb4c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1121ea99822c46089101d09aa4d43ad5679c5883f6c2212e712ba016db5a3ffe"
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
