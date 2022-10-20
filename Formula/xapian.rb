class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.21/xapian-core-1.4.21.tar.xz"
  sha256 "80f86034d2fb55900795481dfae681bfaa10efbe818abad3622cdc0c55e06f88"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7f41e2d95fbde01dcc4750858cdf152708c963bf92e37fd14c7af35fd57fd5f"
    sha256 cellar: :any,                 arm64_big_sur:  "bdb29ed6033c31d37f83d77a9800c6ebd3f64f51974ecb0851b0ad5a1ed81e77"
    sha256 cellar: :any,                 monterey:       "54fd260ba675a7429ba9d870a299f24902eabde2758bf4ce65592c6732bdb7e4"
    sha256 cellar: :any,                 big_sur:        "122d19b6ca19c45af8b9ae46b395370310566c8a920df67b158bfa6c5a975ec4"
    sha256 cellar: :any,                 catalina:       "2d8add7cc126bb89fb4c6e954a74131df7e5f47c90c1a952de6a698a3bd50a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aed1e2c661ca97ad06db18f16972f7453f20df1f4ed0f775ee0bf317f80c12d"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.20/xapian-bindings-1.4.20.tar.xz"
    sha256 "786cc28d05660b227954413af0e2f66e4ead2a06d3df6dabaea484454b601ef5"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def python3
    "python3.10"
  end

  def install
    python = Formula["python@3.10"].opt_bin/python3
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
    system Formula["python@3.10"].opt_bin/python3, "-c", "import xapian"
  end
end
