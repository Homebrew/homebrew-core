class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.2.1.tar.gz"
  sha256 "fa0ccdad12f2d56b7e76537ad7af5355a9e6861c17f793e028741b1e2800bbb0"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "bb84c2a3c8eca1b516a506c2ac58d5f720c1d01e2d128591dec97436d7e4983f"
    sha256 arm64_sequoia: "6d073a4d3b8a9ae34a33e41873e44264b7872d5edf68397ca1dcda255bd56616"
    sha256 arm64_sonoma:  "31c46cdb17a11751f0d46eba90e7e0581ceab3ce28e69f6038687fb0bb71565a"
    sha256 sonoma:        "2c05ab1ccff0da777bf9aab4e5d5bd8d7f861bad8496761101e36e8c8c11426a"
    sha256 arm64_linux:   "ca9d5b9645eff6e9e470bcbe1973b8e191875c274a602f002aa2650d7c928dd3"
    sha256 x86_64_linux:  "564da1a6ef80c36b8c6cf6596778739f26b223194ec45104c7fe0ce8396c597f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_path_exists testpath/"output.svg"
  end
end
