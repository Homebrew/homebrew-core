class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.12/xapian-core-1.4.12.tar.xz"
  sha256 "4f8a36da831712db41d38a039fefb5251869761a58be28ba802994bb930fac7c"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "11d972c6a3d3b4b4eb700a183764bc71ab7c4ea056a1fedab976b093c654de9c" => :catalina
    sha256 "cad63039b4ff1ae0d2af68a4737356f8fbf8a679feb6b1827fce99779c675773" => :mojave
    sha256 "bae68a0933c29c3f1e70089d68ded475e5bcb4a409400e5de06fa43048e9a3fe" => :high_sierra
    sha256 "312ba2283f4de8f16c8f24b53ab2c7f1dd2c7907af3076fb6137bb6946692f1e" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.12/xapian-bindings-1.4.12.tar.xz"
    sha256 "7577174efbee2b893b5387fb0bdf3b630e82f55288a00a4c3ec9fdc463e42a49"
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
