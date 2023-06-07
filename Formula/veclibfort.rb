class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.3.tar.gz"
  sha256 "fe9e7e0596bfb4aa713b2273b21e7d96c0d7a6453ee4b214a8a50050989d5586"
  license "BSL-1.0"
  head "https://github.com/mcg1969/vecLibFort.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "413c6a7004d05f8a880cfe6f43ed144e82baf149d77bd30cf03f91178c4c1320"
    sha256 cellar: :any, arm64_monterey: "22462163750e08279d383a44f688bff75338731d74db718d76fa08ac97802abb"
    sha256 cellar: :any, arm64_big_sur:  "2504b6926cd1fcce519b4614c05edfff3d6023ae31344aaf7874504eb9c25ed9"
    sha256 cellar: :any, ventura:        "0a676d0549289fbebc869eda43fd21372f03114c6323925edbfa61c3c9d77485"
    sha256 cellar: :any, monterey:       "8463699f6cec5840357d1b49f41ee8f322da64626122628442f9f4fb1649c076"
    sha256 cellar: :any, big_sur:        "7df1325737661d476ef4619a4519204818966161ef040c96debdcfe47409714c"
    sha256 cellar: :any, catalina:       "b44b455df99aa2601fb3418445c812d5b0d639bef588f3550716e5984985fa2e"
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
