class Supersm < Formula
  desc "Super Symlink Manager"
  homepage "https://github.com/peeweep/supersm"
  url "https://github.com/peeweep/supersm/archive/0.5.2.tar.gz"
  sha256 "299699209c2af0f91edd659578116dbaac0aa0cd3bd0ad55be6571350fd448da"
  license "MIT"

  livecheck do
    url :homepage
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "#{version} \n", shell_output("#{bin}/supersm --version", 1)
  end
end
