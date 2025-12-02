class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/refs/tags/2024.07.05.tar.gz"
  sha256 "3cd652cb76c4fc7604c2b961a726788550c01065032bcff0a706b44f2eb0f75a"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f963ae3a734ab713133b59a52853c12fc92aee8d2c572c8eeaba96db2ebcd249"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
