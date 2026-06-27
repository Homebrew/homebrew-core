class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/SBJson/SBJson"
  url "https://github.com/SBJson/SBJson/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "a0048240551a426131c54585bac7486047820ccc33ca843fc049dfff2d7e0a68"
  license "BSD-3-Clause"
  head "https://github.com/SBJson/SBJson.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cbca1012b929f00a0854fafcdd3434c90cb5218c0998a62b20a42f13c0fcd81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a59de5f5468e9cce77e7896aad0c49fa5bd5a13865ea937c02b475cc04e892e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd87ed194b6e6f2b45fefd007368bb5ced2800a67047f529ac7a8428592a1d1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dadaa8ce97396562d3a92acf3fdf606c59c6afffba8a0ef6f7d77a39565e515"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-project", "SBJson5.xcodeproj",
               "-arch", Hardware::CPU.arch,
               "-target", "sbjson",
               "-configuration", "Release",
               "clean",
               "build",
               "SYMROOT=build"

    bin.install "build/Release/sbjson"
  end

  test do
    (testpath/"in.json").write <<~JSON
      [true,false,"string",42.001e3,[],{}]
    JSON

    (testpath/"unwrapped.json").write <<~JSON
      true
      false
      "string"
      42001
      []
      {}
    JSON

    assert_equal shell_output("cat unwrapped.json"),
                 shell_output("#{bin}/sbjson --unwrap-root in.json")
  end
end
