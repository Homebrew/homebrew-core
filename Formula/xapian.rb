class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.19/xapian-core-1.4.19.tar.xz"
  sha256 "1fca48fca6cc3526cc4ba93dd194fe9c1326857b78edcfb37e68d086d714a9c3"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9315c3b45b4196bffdb67cd0d175338632a8732e1b54504beedd12b9502234e4"
    sha256 cellar: :any,                 arm64_big_sur:  "a90af30e8e274cb3d2959dbf1634af032df88dea7d179c3e912e961edf92ae4e"
    sha256 cellar: :any,                 monterey:       "15cef8314c190eed223235ee443985c6f130bd99e2a4f5ca111fbae8e3e17013"
    sha256 cellar: :any,                 big_sur:        "594406eadbc569a372949a376a49b4bf5956506c86ba81ad696f7ba94a798ead"
    sha256 cellar: :any,                 catalina:       "bc5c3ce60eb9299c92a4f003cd362e5f8af2d2ac4815ada5cf63a2153fe02ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfbb14f36f134d1fcbd4c3a7e7a3a90ea97eac7063e388668e673fba6afa0efc"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.19/xapian-bindings-1.4.19.tar.xz"
    sha256 "91c385a48951aa7cdf665effd25533f7477fc22781ca712e50b5496459a2883d"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    python = Formula["python@3.10"].opt_bin/"python3"
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
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import xapian"
  end
end
