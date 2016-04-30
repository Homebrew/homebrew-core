class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "http://snapraid.sourceforge.net/"
  url "https://github.com/amadvance/snapraid/releases/download/v10.0/snapraid-10.0.tar.gz"
  sha256 "f7dcf19480256fc2c1db9ab976aa12f786e76da6044cc397f0451524e8031ad6"

  head do
    url "https://github.com/amadvance/snapraid.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "87755e2cc7cfe7525c39f50a7614d54d3f3f0f43440bc24127a291ca5ccf856c" => :el_capitan
    sha256 "10123687aa79706617cf0d62ee0a2d5e27d43ab633d9dc914089d325b3e22464" => :yosemite
    sha256 "d5a7af73bdf89fd946d96139ae94dcb8e5b4e437a8836ba6c9c9a21d618af763" => :mavericks
    sha256 "b5f0e760a5448d744cc279df69686d65d4aaa3d8523ca8d9a8731615ef55d059" => :mountain_lion
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
