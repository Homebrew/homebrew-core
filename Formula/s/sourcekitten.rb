class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.37.0",
      revision: "eb6656ed26bdef967ad8d07c27e2eab34dc582f2"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2055c55992adc5704bba47a724cdd7bf91792cd5b9a290edb20fae3f5bfe1040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e2029ed37a1151357f877689e017031ec02b3e4a7f3481dee354136a0ef57b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a537fa252a93e87370e05294e70355ef17922b476ce83c924c7a8df11f78e29c"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c2adcc597c9c81363a31462f77438e9b72df5eeb389860b15c874d2e730fa2"
    sha256 cellar: :any_skip_relocation, ventura:       "63a0c69b8c07d8d68fc01e1aed95782021417753f6fb3f606e35f214560f7b30"
    sha256                               arm64_linux:   "ed0d6d4dc2112b6ae320927620de3d216549a1ec2dad90cbfd964d827aaa0994"
    sha256                               x86_64_linux:  "b2cff74b0c1717829db601f9a6032096c29b52f2c417c699826d21d8b954ce49"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "6.0"

  uses_from_macos "swift"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system bin/"sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system bin/"sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
