class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.15/xapian-core-1.4.15.tar.xz"
  sha256 "b168e95918a01e014fb6a6cbce26e535f80da4d4791bfa5a0e0051fcb6f950ea"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    sha256 "67094f9ab78c20e0a129746a94752da7539e6cfa120082b5f834f78f777b794d" => :catalina
    sha256 "d3941ae6074eff5a7813291cbb4c384ac1c391ca4b452db198ca9a84a2c395f7" => :mojave
    sha256 "21a4b8ad45725b79136b67377063016cf3a60738db31933088c7a337cd3cb7cc" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.8"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.15/xapian-bindings-1.4.15.tar.xz"
    sha256 "68441612d87904a49066e5707a42cde171e4d423bf8ad23f3f6c04b8a9b2c40c"
  end

  def install
    python = Formula["python@3.8"].opt_bin/"python3"
    ENV["PYTHON"] = python

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"

      xy = Language::Python.major_minor_version python
      ENV.prepend_create_path "PYTHON3_LIB", lib/"python#{xy}/site-packages"

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python#{xy}/site-packages"
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor/lib/python#{xy}/site-packages"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-python3"

      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import xapian"
  end
end
