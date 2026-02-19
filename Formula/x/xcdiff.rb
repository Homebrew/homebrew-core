class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
      tag:      "0.14.0",
      revision: "c2b9cab9f85fe1f1e96ce51d3678f565d3aa8c96"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45974f7dfe74e248ed515fdb45601a02b49dfc321fd1efe77d7776bc2e8116b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8706d53ae848bb3c00fce56616e28bfb919c1ac9ae168801bf534730514bfd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0940788f0145652c0abd75ff03e072da9e4bab46db07582e507c0d40f4616bca"
    sha256 cellar: :any,                 arm64_ventura: "0b0365e447f7d64621488112f3d880b54a7847a895ceb5fe021b67e6a4502a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "26fb6391a35202291acd4f0efa394b943934863bda1f1fdb948c570b3fd017ab"
    sha256 cellar: :any,                 ventura:       "9e9bb668faa2c46294c7bc18b2287adc1e1a48adf81a8c41cad869d6ca023949"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcdiff"
    generate_completions_from_executable(bin/"xcdiff", "--generate-completion-script")
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/bloomberg/xcdiff/archive/refs/tags/0.10.0.tar.gz"
      sha256 "c093e128873f1bb2605b14bf9100c5ad7855be17b14f2cad36668153110b1265"
    end

    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
    project = "Fixtures/ios_project_1/Project.xcodeproj"
    diff_args = "-p1 #{project} -p2 #{project}"
    resource("homebrew-testdata").stage do
      # assert no difference between projects
      assert_equal "\n", shell_output("#{bin}/xcdiff #{diff_args} -d")
      out = shell_output("#{bin}/xcdiff #{diff_args} -g BUILD_PHASES -t Project -v")
      assert_match "✅ BUILD_PHASES > \"Project\" target\n", out
    end
  end
end
