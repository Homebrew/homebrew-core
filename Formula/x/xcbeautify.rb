class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/2.23.0.tar.gz"
  sha256 "ab354f256bcdfd25590c165e8a182e5c3d82aa309222b082de0a82e9932425d9"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c2a1c1349087c5b81e0ebf97e8fd76a46f1aa97b0af823adf4b303edb78daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d73774382f6ea8cbb0f34c1b505fa4c1871ecce5c4eb658f622444539dc0191a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "328a971b1095dd4e8f6ea80b7a6933595b27e7b34c58436c71f05a5944320876"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37ef3cd67dc8ba7683fed85b19a4703520000589a14d14fc50f5d0d5acb4135"
    sha256 cellar: :any_skip_relocation, ventura:       "cb57412409b6b5e9631ca4664499b079004d3488d353ec34d2987e60c5b843ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "290161b05b8a1f495f28b26406da6728aac7d824477b4ead5d348b2ee3fad36e"
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
