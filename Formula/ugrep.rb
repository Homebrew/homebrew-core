class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.0.tar.gz"
  sha256 "b5c5c99d7521a1cb5f30e4ef2f87e42826e164b0ef5ecd923533c2c152c7eeb6"
  license "BSD-3-Clause"

  bottle do
    sha256 "d514b48d676fa44cd590bddc51a3f4612003a954c941acc4613696599d6e3c57" => :big_sur
    sha256 "145b7c6f9aa0b9bcaff6da8f69b197aa1a6e7da3c2ddbcc6dcf491e1cadd4260" => :catalina
    sha256 "ec0a76cdbdaf425ec748f7b0ab22e2f77646dd7759ba8a80f8fb27259a87a9c9" => :mojave
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match /Hello World!/, shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match /Hello World!/, shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
