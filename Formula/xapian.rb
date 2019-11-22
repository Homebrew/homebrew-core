class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.13/xapian-core-1.4.13.tar.xz"
  sha256 "93f8ffffa80c5e6036befbf356f34456cc18c2f745cef85e9b4cfc254042137c"
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
    url "https://oligarchy.co.uk/xapian/1.4.13/xapian-bindings-1.4.13.tar.xz"
    sha256 "7a5a5d2712159ed0a5174a8aabedfc01452a69ebd6e2147d97e497122baa5892"
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
