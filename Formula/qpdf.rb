class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-9.1.1/qpdf-9.1.1.tar.gz"
  sha256 "a2c6fc410ec45df0ca0996b039e00bb6f39cfc76d42d784b7ad7bc9e163f4236"

  bottle do
    cellar :any
    sha256 "142d72298eb8b6be1159b944faad65c04f0036c554c08380c0c2880bd820cf78" => :catalina
    sha256 "729439409ba0644093f521870a9d280703239dd56f261b3613ba1d8847146237" => :mojave
    sha256 "bf691b5ffd8f3075a0fe781f4b566dbca06619a375c39f40e191de7a4785b57b" => :high_sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
