class Tac < Formula
  desc "tac command for macOS (linux too)"
  homepage "https://github.com/WestleyR/tac"
  url "https://github.com/WestleyR/tac/archive/v1.0.1.tar.gz"
  sha256 "e2458464709a0b027bb7834fe6362fb0ee25ac9bbe938050c1d9fbe0d9846387"

  # depends_on "cmake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "touch", "test-file"
    system "#{bin}/tac", "test-file"
  end
end

