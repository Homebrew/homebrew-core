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
    sha256 cellar: :any,                 arm64_big_sur: "f4f208630ce41f77203d5674665cc68ed2d9ef523aadfe59bbb9b603b3c50d78"
    sha256 cellar: :any,                 big_sur:       "5221d8356199601091b9d08fd9d46f5b6cc735ccbcfbaf0a88f9a740ecc282a2"
    sha256 cellar: :any,                 catalina:      "29142b83f9c5366b5a102475a92dfb779915764f1143b48a3f3fc881ea4ada07"
    sha256 cellar: :any,                 mojave:        "c97b7ab978b2afa9341c96cd3f41205dca022663951c4bf5516ab8eabe64d7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77c1412ab0f38e3acd480edbbf5a41a082ce3aad4db12ebc5cd287beccd0bc8"
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
