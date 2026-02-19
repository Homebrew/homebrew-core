class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.30/xapian-core-1.4.30.tar.xz"
  sha256 "4edf9989499e8bc95085c9f7108ed41d69546c34c6eea81da0fa22d95043bf72"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4f3e44b08568874b76556a3f8655fb48367743a6a7801775975a3f7816dfd42f"
    sha256 cellar: :any,                 arm64_sequoia: "ac6712c54ea7000cdcdb0e90a68147cb85d59f1a0dec2be4b1f5634ce977fdac"
    sha256 cellar: :any,                 arm64_sonoma:  "91f12b0e0e5e4078c3af5e15fe13d9b81a42ad8669f1b698f4f4ef5f2ab8ddaf"
    sha256 cellar: :any,                 sonoma:        "316fed98f652f0721b87cb521bcf5ca576a106bb46360b8c23a39be13130997a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "203af3b3f705fb93c5af0d4f1a53841e9d00cf1ea24cc2edfd62bf4cc7ecf391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d87945b42c6bb961b19111b099118cdf304f71bb69d4c4215647c0d4f7d7c405"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.30/xapian-bindings-1.4.30.tar.xz"
    sha256 "abf46acd62b9647157f36b636e1844e7e3bd9457e42312c40029ed63c602379c"

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
