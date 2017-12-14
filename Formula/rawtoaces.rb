class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"

  bottle do
    sha256 "eb16a4a34955b8579c618f065d1957ff3408324a4998707f0996e19ef213fd0c" => :high_sierra
    sha256 "f698e4339e42be14e9a159b7a6a9c8a525a196a72b3426e8ec24b2e27947b0b0" => :sierra
    sha256 "4d1b9e5f78e302a0953803e4a65af2d70517525c70d2c335bfc1c1ad36fc4f62" => :el_capitan
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
