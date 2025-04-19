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
    sha256 cellar: :any,                 arm64_sequoia: "32d59aa449e9047f9eee7409e222ab8be7b6a4da875b90be0f825225d69695d9"
    sha256 cellar: :any,                 arm64_sonoma:  "8e0f73c347016417d481f8657b3fe715e02632c7f119094197ec6dbbfbc612fa"
    sha256 cellar: :any,                 arm64_ventura: "733e5cf3a7d64a1da10016603c79fdbc2b430b6c51185daf10f513f1924c60d0"
    sha256 cellar: :any,                 sonoma:        "eee9c0e9ca6b8ab515b900d1582fda75aed9e4392d7d07809d3c8261e188510b"
    sha256 cellar: :any,                 ventura:       "ec5268cc988abf6d70046c5baf90f829bfa1a1853dcf882a45a4dd86a67b137b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bbcf410008c6d4df675edfe7fdb94a53fda4c35c7f01ad56e579cbff4679e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef9ab01f8a96f66949d32dc3f0616a761b6dbab58965d3788f97e59c1105330"
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
