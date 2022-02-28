class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.12.0",
      revision: "66c5e32dacca5f07c26c0c6cbe01c6796fcc6149"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec62fced4d116c8b4243402dbcfacc0c55106548dcd5754ecaa153ae4e7f5f3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "774f214053e2809df03d256a60adf441b1d804294c17b320e3e55892930374e5"
    sha256 cellar: :any_skip_relocation, monterey:       "8b9ab90db834447f0d9ead155e57f3356fa8620df4d41531bafa30660d4d4ad2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f98c10e854d03ffba33f8bedd513479a95a01949618f57535fbfe0a12be4d3e0"
    sha256 cellar: :any_skip_relocation, catalina:       "757f21867e62e7f856ee8d6e2082e13e4a8762be2c81e3abe123994cee6ea45c"
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
