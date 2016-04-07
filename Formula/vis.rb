class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.2.tar.gz"
  sha256 "3e5b81d760849c56ee378421e9ba0f653c641bf78e7594f71d85357be99a752d"

  head "https://github.com/martanne/vis.git"

  depends_on "lua" => :recommended
  depends_on "libtermkey"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    `vis -v 2>&1`
  end
end
