class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.17/xapian-core-1.4.17.tar.xz"
  sha256 "b5eb8556dea1b0cad4167a66223522e66d670ec1eba16c7fdc844ed6b652572e"
  license "GPL-2.0"
  revision 1
  version_scheme 1

  livecheck do
    url :homepage
    regex(/latest stable version.*?is v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    cellar :any
    sha256 "d85371485dcb478aa6902fabf9506902d91aa4a9922e2a560a7f663f22512f41" => :catalina
    sha256 "c27f0ff9663719c6ceef03fe41b6d96504c6f4a8ee5d7941f788a885382ff4e6" => :mojave
    sha256 "d4a73f84536006e75d09e6998d31dde209e7fb4981c3e082f764b77342f2565e" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.9"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.17/xapian-bindings-1.4.17.tar.xz"
    sha256 "48a65d91e0c3a4a8f4a1ca05dc39225912088aca2c47c0048cc93b09d338ebd3"
  end

  def install
    python = Formula["python@3.9"].opt_bin/"python3"
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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import xapian"
  end
end
