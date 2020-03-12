class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/4.3.1.tar.gz"
  sha256 "4abcb9c9dff24eab44d64d392e115ae774ab1ad90d04f2c983d96d7d7f9476aa"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "231e8a721b0829fbf91055cb9ad086b4207e1fa2052f6a84f2929b7e425dff79" => :catalina
    sha256 "15f35dba3b520b4af64f4eddd47a74f11d90162d6ace3fa0ef6b8fcec47f816c" => :mojave
    sha256 "00f113068cf6ef7565a81d1243f745c19f0dcf595bf9c78e4ebec6dd57935433" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
