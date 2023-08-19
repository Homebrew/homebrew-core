class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.3.tar.xz"
  sha256 "8cae258247cd2623e856ea5e2c62cd7f09e9e3e043e6fc63bbd1abec3d3fdd93"
  license "GPL-3.0"

  bottle do
    sha256 arm64_ventura:  "edac738221df3600f641718d8ef503d74b91f8b1d70152908d8f4e8543ea1f3f"
    sha256 arm64_monterey: "c40ad559ccaebe83031cb3118bdcc2ade53433fd9d733a3e750a8593e44c54d4"
    sha256 arm64_big_sur:  "c3031fa858e73ad07c42be20c11c97f8b8b46c52f3ae9c695fa5191751db7784"
    sha256 ventura:        "3285a1b79c8401fda37feed9166fe87cf7ef93e2e210e178c77a75ae203b855a"
    sha256 monterey:       "5833155618b0bf4e4a0e2ee646a7f8585c4ef541f5548911d4eb09af38131327"
    sha256 big_sur:        "b9fe9b70c28fb4bbe8427f1465cd9b99deabdbf10de7260801f95d1181f8e8b2"
    sha256 catalina:       "e382adfc56df5e2fd3075f9183e0513ce85ed7358699f935272d57411d7979b9"
    sha256 x86_64_linux:   "d00ab93f179b7714db5dd3eb7f2679f31cfa2fda5596387d9d6f310a6a931129"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
