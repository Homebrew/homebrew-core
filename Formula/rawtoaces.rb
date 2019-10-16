class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 6

  bottle do
    sha256 "4f2fef8030ff9f13f7df562996dfb18fead52c082d9c8746278ba4badd486d7d" => :catalina
    sha256 "924faea950781e51e7677fb8f691161002ff786873562408bf810d5b5891ba4b" => :mojave
    sha256 "321d3c34d1b7366f816667cb2196c83a8d6c202107290febac0aeffd5442ddc7" => :high_sierra
    sha256 "168866987a9e150a929ecca2678b6a601220235146d62d2eb18ebd2b89e7afd3" => :sierra
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
