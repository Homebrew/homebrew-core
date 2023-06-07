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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "94282bf584c6f10784f1331f5c0f45a6e5fab4966e62cdb3046f6cb00f1ad305"
    sha256 cellar: :any,                 arm64_monterey: "19ccb741b677fedbc18aab3eba8e3448f93e24e4495453091f5b4911ddb0ad28"
    sha256 cellar: :any,                 arm64_big_sur:  "c6eaa3e9ca0c4433a9a68a001d43359a769fe332b20428842682bbf349a9d63c"
    sha256 cellar: :any,                 ventura:        "69a1f2026b87b096a202506f2e249392affdfcdc3bc7f5dade8e813b1b4d8d7e"
    sha256 cellar: :any,                 monterey:       "e3935fe73611fb3db2fa98dcb151e6129950bb9dda20d2b8fcf351abdec6f560"
    sha256 cellar: :any,                 big_sur:        "8d97587e1fc548777532581c1d6409e39512309dfda50eb764c154bfdefd765a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13c59d710c79b257cff9ca1bb60fa9c9345cceddb6b7706932e6dd2d85ba62b"
  end

  depends_on "python@3.11" => [:build, :test]
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
    "python3.11"
  end

  def install
    ENV["PYTHON"] = which(python3)
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"

      site_packages = Language::Python.site_packages(python3)
      ENV.prepend_create_path "PYTHON3_LIB", prefix/site_packages

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/site_packages
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor"/site_packages

      system "./configure", *std_configure_args, "--disable-silent-rules", "--with-python3"
      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system python3, "-c", "import xapian"
  end
end
