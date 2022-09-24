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
    sha256 cellar: :any,                 arm64_monterey: "0ad75eb7e4d586167d16c897cea120c5ff4b59693c56fa155099da4f604137c5"
    sha256 cellar: :any,                 arm64_big_sur:  "25aab82bb25690a71eea73a9b4a06f79b1ae908a2747b8d74414b1f3f2f3a6a0"
    sha256 cellar: :any,                 monterey:       "21171c4dec26f104a1c9326fe4f694293109c935c444c0d2f0f98ebc66311f0d"
    sha256 cellar: :any,                 big_sur:        "f617283a4d2d27be246c6ebc926c39bee64934621a2707d117f6f90c9b59b40c"
    sha256 cellar: :any,                 catalina:       "2a2c3abe14ea1db4183de57020c6c0886e386f3bc72bc8e4b5402a93ac793367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "942424d10a513a161e32b347e2864fcf19fea5637717baf0db91433f7aec5b69"
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
