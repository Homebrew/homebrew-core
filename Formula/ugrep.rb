class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.4.tar.gz"
  sha256 "3de80f56e82ac21fda574334a1e55d3a9027c156d4b1ce1b0e96ea99b25cda32"
  license "BSD-3-Clause"

  bottle do
    sha256 "3e1ce591b9b4dfa49c3d00c472e60179d91bcfa89119b4c05f5ca64950c2c5e0" => :big_sur
    sha256 "4cab8e9221bfa059f213a18bd837dd818ad9e38defdc27725534d69d07437f7e" => :arm64_big_sur
    sha256 "79c66bf303f960663e9264afb2fc2390ec3cf647e4c70763ba00ef4a09c172a2" => :catalina
    sha256 "45232be0add69494dc4a652bc92f8d2ab6257059a56c5da79de0fb6610bef5e0" => :mojave
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
