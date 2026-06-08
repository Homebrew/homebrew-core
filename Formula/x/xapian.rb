class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/2.0.0/xapian-core-2.0.0.tar.xz"
  sha256 "6cea3f49952a47224439a40bdb3608f928d121ad8721b9921cc42802d548ecf8"
  license "GPL-2.0-or-later"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b3662944f7d62252755c60a30a9d45c278030ec35ff2b26df81a1f771db6679"
    sha256 cellar: :any,                 arm64_sequoia: "acea926df0ec8313a5ce4200b0d16d37799e6061c3faaffe1758b5fd44c7da03"
    sha256 cellar: :any,                 arm64_sonoma:  "21eda4fcd6301dcc53653840f69fb24299b132b9d4ce17fc45888cb132f0e5bd"
    sha256 cellar: :any,                 sonoma:        "6991ce3e145fddebb0081696d5b590b2e5b93cbadbc76a958263ba170bcb7b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a2cd147c9b3b56210d73a97acc54106953e62619b08af56c8236e5b6a73a251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1c8e93aa12e1285ecbf15640e8fcede10547801eacea3333833417255eaa02"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/2.0.0/xapian-bindings-2.0.0.tar.xz"
    sha256 "9a544b69c31355a92edbcd4102cf0f1ec4407fd0a4645f4870fb52300b736910"

    livecheck do
      formula :parent
    end
  end

  def python3
    "python3.14"
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
