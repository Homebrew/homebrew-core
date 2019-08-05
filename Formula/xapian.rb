class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.12/xapian-core-1.4.12.tar.xz"
  sha256 "4f8a36da831712db41d38a039fefb5251869761a58be28ba802994bb930fac7c"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "4199eabb24c1d33ade627d57e343969a10bfc6be52725d36643ae63bf8f0de03" => :mojave
    sha256 "1554dd594922fa2a7bef9e85363db303d1bdef24b73c78e7e0734c71597b7481" => :high_sierra
    sha256 "f357ee9a8e6b2fab072d0c60e2544339931a9712200ed1ab40a972e82ea0b671" => :sierra
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
