class TestPythonInHomebrewBuild < Formula
  desc "Test the version of Python during the build of a Homebrew formula"
  homepage "https://github.com/lelegard/test-python-in-homebrew-build"
  url "https://github.com/lelegard/test-python-in-homebrew-build/archive/v2.tar.gz"
  sha256 "ea33af31bed6e2c83d92201db69f2b3e2dd6f376e18be0f9203b0e80f695c039"
  license "BSD-2-Clause"
  head "https://github.com/lelegard/test-python-in-homebrew-build.git", branch: "master"

  depends_on "python@3.10" => :build

  def install
    system "./test-python-in-homebrew-build.sh"
    bin.install "test-python-in-homebrew-build.sh"
  end

  test do
    system "#{bin}/test-python-in-homebrew-build.sh"
  end
end
