class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.25/xapian-core-1.4.25.tar.xz"
  sha256 "0c99dfdd817571cb5689bc412a7e021407938313f38ea3a70fa3bf86410608ee"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a1a33a0c92d45ef59423597d95a70d73725fa523d0fb624c499397c7d4d65515"
    sha256 cellar: :any,                 arm64_ventura:  "68e1414a9481c3369996fb37e9ad3a662b7c6228f5fa492a0cb42030a567744f"
    sha256 cellar: :any,                 arm64_monterey: "03a24ff40c24b7809c8d67fede7602fd5f366cce0b76047968b3a1c1ce16f091"
    sha256 cellar: :any,                 sonoma:         "50bb168f2fa15d167c499da2893f27882cec2ef523ddcbdedf61f5eb467b2539"
    sha256 cellar: :any,                 ventura:        "64f495165dee6ae9fa3eac8316c6f38b9b94681e6291c15f737d1c34afd19ac2"
    sha256 cellar: :any,                 monterey:       "8b8a25c34242eef32c1495abb93c679f95fac925d7f6249bb27ad4c1cb2b592f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7ff30f5f28314f540f56ca75bd5942fc903db9de8fcf66cf5fdbe426caafbf8"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.25/xapian-bindings-1.4.25.tar.xz"
    sha256 "068314fca3f54524701492df432fa54c485fd4e39613ca2cd275e136964e81a9"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def python3
    "python3.12"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = which(python3)
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      ENV.delete "PYTHONDONTWRITEBYTECODE" # makefile relies on install .pyc files

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
