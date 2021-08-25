class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.18.tar.xz"
  sha256 "71c0ad72eb31dde3cdcfb76f9fe752eb2d137a49d5d49ee8e2ee80bbeac42c67"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71be3468fb96a18bdc21468d75473e8b2058a96c17aa2fdfd9a094e0a3d11bd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc64b5a8c222bb22e5f3319835b3128fcfc61d3fde5e192b8171b0c212233e10"
    sha256 cellar: :any_skip_relocation, catalina:      "7af71ce1b492802a1fc88484d6ae8eb95c924dc4363f354dad1693984d60ddd2"
    sha256 cellar: :any_skip_relocation, mojave:        "f136d2f2959574e52b0431b4c4fe8ebe88724a52911fea8ffe103b915012ed71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ef77fb816335301824c254a8d433441345c7a40f9bf977646cf1bf28312293"
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
