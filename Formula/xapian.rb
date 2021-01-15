class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.18/xapian-core-1.4.18.tar.xz"
  sha256 "196ddbb4ad10450100f0991a599e4ed944cbad92e4a6fe813be6dce160244b77"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/latest stable version.*?is v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "5645bdbfbf7ebb1e0d068bb51cce7a28c1e4102a29da6647b5959d0607100d21" => :big_sur
    sha256 "255bee7728a81eaf941120a7085c724b57dfe074de8a8987cc0403d01572fef1" => :arm64_big_sur
    sha256 "f9e6103d9938f2708d0d5d38030c833c5f78d02efe53091616d1fd9e645a69ee" => :catalina
    sha256 "9ad6e312f0949659d3d96f7ef1edc63cd4e8b2a45e7a94243ffa4cb3abf940f8" => :mojave
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.9"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.18/xapian-bindings-1.4.18.tar.xz"
    sha256 "fe52064e90d202f7819130ae3ad013c8b2b9cb517ad9fd607cf41d0110c5f18f"
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

      # Fix build on Big Sur (darwin20)
      # https://github.com/xapian/xapian/pull/319
      inreplace "configure", "*-darwin[91]*", "*-darwin[912]*"

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
