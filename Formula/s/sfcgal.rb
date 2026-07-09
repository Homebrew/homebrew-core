class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.3.0/SFCGAL-v2.3.0.tar.gz"
  sha256 "5f6aa1838e5ae31523ebf410cde0240b7a88d7e062b7ffff945e4fae2aaba0fa"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a19e4d45890a856c054b0d205241cd77f76d78f9aaace0f7db26142f013777cf"
    sha256 cellar: :any, arm64_sequoia: "49d024ceba5c90ae0afcbcbd701892ea279768354a75f3c7a623ee635b25152c"
    sha256 cellar: :any, arm64_sonoma:  "00f313d58946f951077954e2cad228202aa2e226f7270118973291e12d498a0e"
    sha256 cellar: :any, sonoma:        "1059b7f6a43637396f4b4f5844ff3e1bdefe680bed9bc7176f30edaaf1e0b9ed"
    sha256 cellar: :any, arm64_linux:   "b9723d309477b59bfabdba6453076aaa7f7cac4e26cd718aaf8108dab4b4bd3e"
    sha256 cellar: :any, x86_64_linux:  "f19dc9fb3c41efdb00a9a2aeced333f475604ef629f3f7d0e6ad82e487e3dc17"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    # TODO: Drop SFCGAL_WITH_EIGEN=ON once SFCGAL enbles it when Eigen is detected
    # See: https://gitlab.com/sfcgal/SFCGAL/-/merge_requests/778
    system "cmake", "-S", ".", "-B", "build", "-DSFCGAL_WITH_EIGEN=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
