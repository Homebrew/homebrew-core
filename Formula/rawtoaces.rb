class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 4

  bottle do
    sha256 "5679390ca59f7e952775caf73786cfe8cd9f77cfa72c997d4f6a5e2b970a14f3" => :mojave
    sha256 "564c0e6348c28412f775e509be984366ec1d47f24db264bbdcba836fbdba2d4e" => :high_sierra
    sha256 "b91eb2cd2c4c2bfde337fc595a6e47069838a6abe67c4b8f8a633528bd74de3e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
