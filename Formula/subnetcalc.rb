class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.19.tar.xz"
  sha256 "13f35abc0782c7453da22602128eb93fa645039d92cd5ab3c528ae9e6032cd67"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "530958e6e65c9ef4de865013c1cd937862d816ed87edfb888aa8bba38405f957"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11b113fcb125a8da85e6c3e14866c06b0d7e09e83b439b200ec4721469248694"
    sha256 cellar: :any_skip_relocation, monterey:       "a7663859c98118741370fedede62527215c11a2967dddc4235d059dc27082c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d81c3cb134879270acfc762ae17aa653acbba88cfc258bb8c1ec574952f28f7"
    sha256 cellar: :any_skip_relocation, catalina:       "6becfcc6f881532d19dd0aa6b865fbbb9f88fc63329effa7e8e7bca8503c8f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9583e8d925ec45ae6edece69a4154b30efd7a22ad69bb9d7aca0177442b86af"
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
