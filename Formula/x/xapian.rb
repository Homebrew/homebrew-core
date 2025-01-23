class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.27/xapian-core-1.4.27.tar.xz"
  sha256 "bcbc99cfbf16080119c2571fc296794f539bd542ca3926f17c2999600830ab61"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbb0be7be62378361f90292bc53d05d58811ad23501e8dccd026f2aedb51b9fc"
    sha256 cellar: :any,                 arm64_sonoma:  "3c657fafac679443c1c69a9409a7dfbc281d3d29fb6f54989c3736bd0a3d227c"
    sha256 cellar: :any,                 arm64_ventura: "7e2ae9e288f52938deff37d44c64c34071048cb86f7f4bee09c2061f0a5a0b7b"
    sha256 cellar: :any,                 sonoma:        "c0f1ac0afa541a55adf7bacd15a107c92835cc3e131949f8553ccf767978aa3e"
    sha256 cellar: :any,                 ventura:       "648ff983c9da6b823efef34fd26df56bc3eda5b3f8331bec01195f96807269ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "429452ca722ec4a435962d38d1309989b1c0df4b76900fcfa1ff106081513a1a"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.27/xapian-bindings-1.4.27.tar.xz"
    sha256 "ba3b5e10809e579acd11bd165779ce3fd29a8904ea37968ef5b57ad97c3618ba"

    livecheck do
      formula :parent
    end
  end

  def python3
    "python3.13"
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
