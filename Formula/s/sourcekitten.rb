class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.36.0",
      revision: "fbd6bbcddffa97dca4b8a6b5d5a8246a430be9c7"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6d7185725454aa6e7cf946666dd3a66aca84965a07b3c0cb7c6d78caed08d1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de09af7ebff8f1fefb5daa5656ceb3d768b06ed9c1825783680acdcce96acb86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b65a68b37177be39565b54be6149dba1f3ba42fcabc26ced151c7f7803edc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dffc8ba081641777ef1d0606130582d2eb2a505926c9dd3230d17acf9336850"
    sha256 cellar: :any_skip_relocation, sonoma:         "a75f960c137193ded31c765fb96ecda9bc1c6f8893f32a5becd02c090a35463f"
    sha256 cellar: :any_skip_relocation, ventura:        "a3e70dc9ec689ee44363e943f3ef32020bffdb894debab04f52b24a7f993c462"
    sha256 cellar: :any_skip_relocation, monterey:       "803e0dfba2e8333141c7dd5fd6bda0310f0a917a6c79f16aa929bae56c3adcde"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos
  depends_on xcode: "6.0"

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
