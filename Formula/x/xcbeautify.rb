class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.3.0.tar.gz"
  sha256 "337e00885596279cd4b11fee995513e285b38f26c6dc4aaa353ad5fee9651cfe"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df22ce106883975ae30272fde0b264c06d5b6c422d2c3640bd02c1640ef52be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f62540be8f6e6bf6782ab73e89202fbfbe42462bae44c884fd5b02d24aebf59"
    sha256 cellar: :any_skip_relocation, sonoma:        "a96aca8328b40e6020d77d678b841eb6116d007811bb08e54e61a9bd2b14200e"
    sha256 cellar: :any_skip_relocation, ventura:       "3c2ae58f8bc7eede4ca33401ffb77e3ba7593e7d10009919c2eddbd4dc2a33bb"
    sha256                               x86_64_linux:  "30ee758074c65759b6be80995eeb47626e77a862e7587708ebf6e56ec3a3cd49"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
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
