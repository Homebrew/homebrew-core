class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v2.5.6.tar.gz"
  sha256 "02fc3e3575a6d5482d19e748331c4e3a0e5c85d95c96dbceb06abbab5cbb8cdf"
  license "BSD-3-Clause"

  bottle do
    sha256 "29473f43bba0f64a8b54fbbf3232857d417d1679c7b4e0db1e1047771c6acfa0" => :catalina
    sha256 "43f5847d9df61e9243b291531749c074e6527bc25955e6ab9fb44e4d9d988e61" => :mojave
    sha256 "c4442aefabaf5d41a5cf01ce1615257cd9ac7945083ff38158641ff8176c57ee" => :high_sierra
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
