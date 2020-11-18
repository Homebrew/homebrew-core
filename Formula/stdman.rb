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
    sha256 "5ac1a49ad04d00ad240a8dea6ff1069b20b3166d90772db5865fc2ac25ec7c98" => :big_sur
    sha256 "0c7500e80257d9639866f2216199b605d1bb33abb3a11cca5f8c8baae5807e60" => :catalina
    sha256 "a598b69cd962050da6e5ec4bbfb844e5c84ad9a6b2afc4aa8670591cab05090e" => :mojave
    sha256 "a1d5c1b4e19ae36a4526f71a47c1868547fbb573579977d299accb678ec93234" => :high_sierra
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
