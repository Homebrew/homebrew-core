class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.29/xapian-core-1.4.29.tar.xz"
  sha256 "c55c9bc8613ad3ec2c218eafca088c218ab7cddcba7ef08f3af0e542f4e521bc"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1eae8800f5f28c7231afd2bee2818d2065e5fed8e7d307c2fe1d797c8d8fbf4e"
    sha256 cellar: :any,                 arm64_sonoma:  "95c8bb4a5a73ef642ab6e6d2ee6b59cf21217fa102333ced9696a14cff7f4da3"
    sha256 cellar: :any,                 arm64_ventura: "d8b9b13a47f436a74438663123b567d95512cc7d91fe60c11eac10bca5555f55"
    sha256 cellar: :any,                 sonoma:        "a1b006c534ecc66fea932078de4221d0d385b3391d20aea13a3bace640fa047c"
    sha256 cellar: :any,                 ventura:       "19a9b99a6088ec521d2af29a14afc8f86b5674cd08330698e2d3a30caa1dfb19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e45335d6b4555bd6fd7a6a85bfe6a1a9b635a4418cc9b43e7de957301d3c1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87d97371ec436679abfd002d828ff14a00b4e4355faeef1e385f67a2c25412d"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.29/xapian-bindings-1.4.29.tar.xz"
    sha256 "1740e927bb6850ef67d99a0b808a1b7c9af3f16c15577e0261bbd3fc016fc8ce"

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
