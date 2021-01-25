class Stdman < Formula
  desc "Formatted C++11/14/17 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2020.11.17.tar.gz"
  sha256 "6e96634c67349e402339b1faa8f99e47f4145aa110e2ad492e00676b28bb05e2"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72cfb38a8ed45c88a2a70cf75029fe5be4e53e18a19a85e532a482714b68d32a" => :big_sur
    sha256 "f865e4982fe6eeb4674df33b984ad994c863d26e1ef209c13ed688ae2bda30b7" => :arm64_big_sur
    sha256 "4cffe0f6e5f997fdef7932ca12d10f1d0a0501f659028a277166e9e1678a93a2" => :catalina
    sha256 "741674ceaa66f53fd98c146dc1123c63d981997c4ef7bf171f671d83f8b87959" => :mojave
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
