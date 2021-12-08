class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.10.2",
      revision: "d818e734052c6cf373aa6aa0456ef6e69149975a"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf05e91e14df1924bdcab4f4d59a485c24354d5232261c6280371c327384d87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94d6be8e9ed7821e9d13ef560be7dca04465b510d6cf7b00b830dd574404a2c1"
    sha256 cellar: :any_skip_relocation, monterey:       "0ecba4e9cf8d241dc8f51693cef7bdd902b9307ede007686f78d805f4880e32a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c451182bd03acd5db9432cf4d1d9ca79cd7258890ff51d5ddf3b66974ff36f1c"
    sha256 cellar: :any_skip_relocation, catalina:       "9ab4920e2a60862d0a243e3b3028333ad1839e5cfef561abde8cdfd54a92211d"
  end

  depends_on xcode: ["11.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
