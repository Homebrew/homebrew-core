class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/2.1.0/xapian-core-2.1.0.tar.xz"
  sha256 "8e1259586d342e3d12b5e1f772e9185a10f2ba16e541566b5c3c239f71b8aacc"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "863e3c289292470c672f4674fba1b1c9f6bfd2260082ae0f88722f1772cdf1af"
    sha256 cellar: :any, arm64_tahoe:       "1fdb939960308f643cd58fda7b79c4a37b720e9631d3f75004243f7f8560ff7d"
    sha256 cellar: :any, arm64_sequoia:     "30a37bdafc5c9b8e7cf98ce7b18182aa9c4a365c75aa1084922cda357be749d2"
    sha256 cellar: :any, arm64_linux:       "450ab6a587eee6a5d54655d696c452da491b049862935da78e58b4c4915c3a6a"
    sha256 cellar: :any, x86_64_linux:      "f407920cf5498ebfb3340dc12856f1baf550166a10e945efa1666172afe92f02"
  end

  depends_on "python@3.15" => [:build, :test]
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

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = python3
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    resource("bindings").stage do
      # TODO: Remove when the release wrapper is regenerated with SWIG 4.4+ (xapian/xapian@64c7de24cb)
      # SWIG 4.3.0 swapped the mutex unlock/destroy calls, aborting Python 3.15 at exit:
      # https://github.com/swig/swig/commit/892be2b8024d391dbc78028a2e99b7800db2ea99
      inreplace "python3/xapian_wrap.cc" do |s|
        s.sub! "~Mutex() {\n           PyThread_release_lock", "~Mutex() {\n           PyThread_free_lock"
        s.sub! "Unlock() {\n           PyThread_free_lock", "Unlock() {\n           PyThread_release_lock"
      end

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
