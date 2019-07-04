class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/RELEASE/1.4/xapian-core-1.4.11_git103.tar.xz"
  sha256 "7402311ac96c4386894eab8e240c5c022ad695757710dc437514a551e6f1d3f1"

  bottle do
    cellar :any
    sha256 "f802e17710ae6f4b01e2a85103537a5b39915984700207a42dd1ab1da43dfaf9" => :mojave
    sha256 "df8a268b9016f9b8cc60290bd28aa8281bb8739c0b13957425d48f22d24cb4da" => :high_sierra
    sha256 "a1a49718ad026797c150e012c712ad69a9d6e5a278a4750d0bddd1656a41014a" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/RELEASE/1.4/xapian-bindings-1.4.11_git103.tar.xz"
    sha256 "cb38fb5d5bb68b7181d1ff1be9a9405c2c7e8dfb4d878e0ab540224c7fc08d79"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      ENV.prepend_create_path "PYTHON3_LIB", lib/"python3.7/site-packages"

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python3.7/site-packages"
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor/lib/python3.7/site-packages"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-python3"

      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system "python3.7 -c 'import xapian'"
  end
end
