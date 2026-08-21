class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/2.1.0/xapian-core-2.1.0.tar.xz"
  sha256 "8e1259586d342e3d12b5e1f772e9185a10f2ba16e541566b5c3c239f71b8aacc"
  license "GPL-2.0-or-later"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "caebee6380675c6e7fdff05cb7ec7ed345ca2d736a425991fe572fb387b65ade"
    sha256 cellar: :any, arm64_sequoia: "ae5b3fb391054b0ee57d332b3fe2f04c907a3998dacadca392801a50537d4e70"
    sha256 cellar: :any, arm64_sonoma:  "1543d604bd57b6d7881cdfaea23ed496d7be019b7a40cc1d9cf21c33b918fe20"
    sha256 cellar: :any, sonoma:        "d5b371abe5b578dc1c7ffad9dd449ca675ebbbe94f9ec37e419e1e1b59414bec"
    sha256 cellar: :any, arm64_linux:   "43470f42143afcd6821981500736b01ee0f7393414e8176b06ce706c4099a2ec"
    sha256 cellar: :any, x86_64_linux:  "e59b982d200537bda5d76b279bf5ef73af38fc34fec7defd8a3b90f596803aa2"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/2.1.0/xapian-bindings-2.1.0.tar.xz"
    sha256 "f52ec189f13b4fa66ea625a6eb94bb32dd651b9ec806be6a911dda54cbe3875c"

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

      ENV.append_path "PYTHONPATH", formula_opt_libexec("sphinx-doc")/site_packages
      ENV.append_path "PYTHONPATH", formula_opt_libexec("sphinx-doc")/"vendor"/site_packages

      system "./configure", *std_configure_args, "--disable-silent-rules", "--with-python3"
      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system python3, "-c", "import xapian"
  end
end
