class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v2.5.3.tar.gz"
  sha256 "83f2017ba05f7ce7ded74097832df071d2be89d41b357f45c4dce801c2a0cae6"
  license "BSD-3-Clause"

  bottle do
    sha256 "ef04ef69c80977b3dd2edd4a678187ea744ece6e59a9e84385d5ca51fe35b255" => :catalina
    sha256 "09b09381fce5c7cd4f1c758831f7991bd6cf1998e2017da27a6ee15a46f6dc75" => :mojave
    sha256 "2708c0837b93a398dbf9b6f177a784c768729b213a8ca55261990007f3aaa618" => :high_sierra
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    ENV.O2
    ENV.deparallelize
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
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
