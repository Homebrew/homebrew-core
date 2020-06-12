class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.15/xapian-core-1.4.15.tar.xz"
  sha256 "b168e95918a01e014fb6a6cbce26e535f80da4d4791bfa5a0e0051fcb6f950ea"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    sha256 "805a00d6553c550fe560eeef68e3f4a7aae6e8d2b22078076f5e9ad3f70872f8" => :catalina
    sha256 "fecab9b32680b8df85e42387b4e01ee8a366ec9ed1cd1aef42f161d387e00d8d" => :mojave
    sha256 "9807db08b140e2b033ea22b32a15755c2fc85329e63d4eb72ea0b711e1ca28d6" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.8"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

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
