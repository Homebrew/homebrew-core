class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.3.tar.gz"
  sha256 "fe9e7e0596bfb4aa713b2273b21e7d96c0d7a6453ee4b214a8a50050989d5586"
  license "BSL-1.0"
  head "https://github.com/mcg1969/vecLibFort.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5127775a0d623365c007a460845d2dd1577e688418a105088a9c4e35e71cc7ff"
    sha256 cellar: :any, big_sur:       "0bac71927736c56d331f113896ed0c9b61dccd23c26cdf1e36508b2711f9d949"
    sha256 cellar: :any, catalina:      "bacc73e19f66c5b9cbd1436cbac4a6256a638724961bc17a79a844a0c5635712"
    sha256 cellar: :any, mojave:        "a3d1f23a1ce7f3044b50ba81baf3c1ee058070baa33a7d2a8ea14827ac6d0650"
    sha256 cellar: :any, high_sierra:   "072c7d553e857a6b4c760f921b9eb6281e7d91c5911f5257915bf6de8bdee97e"
  end

  depends_on "gcc" # for gfortran
  depends_on :macos

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "tester.f90"
  end

  test do
    system "gfortran", "-o", "tester", "-O", pkgshare/"tester.f90",
                       "-L#{lib}", "-lvecLibFort"
    assert_match "SLAMCH", shell_output("./tester")
  end
end
