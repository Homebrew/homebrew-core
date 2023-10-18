class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.23/xapian-core-1.4.23.tar.xz"
  sha256 "30d3518172084f310dab86d262b512718a7f9a13635aaa1a188e61dc26b2288c"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e02d698795533d2fc00d8bdcb5e7c1e299153dd050b663e9d8f0dd804a8f940"
    sha256 cellar: :any,                 arm64_ventura:  "964bcaecbc86ffc7a83bf1f51b2f80f860a2936cdecdf99aaf101f866689c26d"
    sha256 cellar: :any,                 arm64_monterey: "71a995c4879a0c0cc02a6615de1e585d54d4b6fb95c2666b3e73f06ffb469b3b"
    sha256 cellar: :any,                 arm64_big_sur:  "4d76db4f93a0d4bfc8697dcc6d946d045c21da7b3abd4d09225649a714ec0cbc"
    sha256 cellar: :any,                 sonoma:         "45fd9e64ee86dc7256c954d15cb540b36a41da5486bf416218340ab7cfddff69"
    sha256 cellar: :any,                 ventura:        "b38555358adf041578b80fe2bbfe2e7a6783362394e6aa94eebd9eed1a92176d"
    sha256 cellar: :any,                 monterey:       "dc235c003c6c9d47846d34e91f1808b94e2eaf92067ec714a8e94d525f88111c"
    sha256 cellar: :any,                 big_sur:        "1067cab11ff4ce022d78040b1ec29228075496a67fb0e593bb1a791bad5e45b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b22baed91ec43e7de0d55aabbc5fe9820a266d872be5453393f302726e6ec4c"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.23/xapian-bindings-1.4.23.tar.xz"
    sha256 "e0bc8cc0ecf0568549c50b51fd59e4cffb5318d6f202afcd4465855ef5f33f7d"
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
