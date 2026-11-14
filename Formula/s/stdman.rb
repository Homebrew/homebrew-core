class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/refs/tags/2026.11.13.tar.gz"
  sha256 "deb29cc1df1ff34618f2cd4b222295db68428c462d7526aed92bd13400019740"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32e372fa9a6781f4c6314b63bea66cdba18b8547bad9bbff657564217a3e1643"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
