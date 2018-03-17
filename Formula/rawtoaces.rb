class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 1

  bottle do
    sha256 "966afd878bb5e6fd3e7fa494b6b75a551df8d32dd75eca1303cc26b4b7b0e1e3" => :high_sierra
    sha256 "fa253177e28a4ff685c7ca513cd7a85010a51f752c67feca2faddc7496434af0" => :sierra
    sha256 "e36620881bb6a6bc53683708b2189083be8c6cc21e1ec7b377a6010c8a8c0c63" => :el_capitan
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
