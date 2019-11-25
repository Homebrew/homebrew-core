class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.14/xapian-core-1.4.14.tar.xz"
  sha256 "975a7ac018c9d34a15cc94a3ecc883204403469f748907e5c4c64d0aec2e4949"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "ca56eb658ab73e5eb7f75995b131599e8ca564d9863e597fd058a18b405c8fdd" => :catalina
    sha256 "7b3ed25c8416ba7ae6423cd96a71ad175bd07a62bf17fb1e80e36b4e9c6f7c30" => :mojave
    sha256 "79293e9bbcdf86cbb286b90cd410dd8977d28c81c07b960095ff3515d33b9050" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.14/xapian-bindings-1.4.14.tar.xz"
    sha256 "5609d5680650d8a424683eb3fe3239dc8468341cabe0861e7be5018b383b6161"
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
    system "python3", "-c", "import xapian"
  end
end
