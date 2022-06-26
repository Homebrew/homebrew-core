class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.5.0.tar.gz"
  sha256 "4150ed1256f7b12b928c65113c485761552b9496c433778aac3f9afc3e767080"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aeb9e48531e6c0207c520039fb19151044deaffeea109f4be6c2cba0163d4cb1"
    sha256 cellar: :any,                 arm64_big_sur:  "0231ca8fc326ec9888c3da9f07eef767ce69efd947614a0d19b3d4f1e4051192"
    sha256 cellar: :any,                 monterey:       "ab2c2353c248e27831c942c7e369e3402c5d6df6f49a02080b1f4903c32e91ba"
    sha256 cellar: :any,                 big_sur:        "db5e30a0195c38a79630c88cc32a37e0f837ece980dd039a042c4879d9365c4b"
    sha256 cellar: :any,                 catalina:       "b25d141342e3ebb09d42f528fd2dcb253c6f729665bc39f58ff1fbe4ca757c72"
    sha256 cellar: :any,                 mojave:         "d704696e7f9ab9c095ce6f59db3725576ea7ac4a540e115a3928feca3cb75b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787feec863b81e78f378a46b60505051c4b8b29b25c19e3d41b5c94c8ce88562"
  end

  depends_on "nettle"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system "#{bin}/rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
