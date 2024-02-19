class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify.git",
      tag:      "1.4.0",
      revision: "84d24a9854e6fdcd2c91122d50a3189b072e8136"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d385bf64fa78e606790182eb51f0fbc0b6dccce34ce20c7028d095073a42175e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3837069522655f5f6273291cf2c9ee82511d038a244600bfe499ec07cc0a464"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d6e61c71e6a387a761c8616b10836e01cc59637c0b69165ff823626720b8e82"
    sha256 cellar: :any_skip_relocation, sonoma:         "12ceb05ec96886a8194b6b2149d3cb410297b640d414be8b7329c868978b45e9"
    sha256 cellar: :any_skip_relocation, ventura:        "3572b97c6271dc9fefe856018d87ffde775f1b4c07d1b810005b4170344b43f6"
    sha256 cellar: :any_skip_relocation, monterey:       "8e8829c7ef83f6738435baf383fc72f9b78a4b241595ee58db53b3c2489744c4"
    sha256                               x86_64_linux:   "1f52ffa3bf532545b5d292ad8380f492bc3686003c8e6915d266ab212b8d3719"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

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
