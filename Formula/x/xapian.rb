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
    sha256 cellar: :any,                 arm64_tahoe:   "2048acc4b5bf066a591e66dad19a1e28cf6f810c49da2410cbac9a697cd15faf"
    sha256 cellar: :any,                 arm64_sequoia: "b23b26f2f036d6e109bfaa0dfb010f4e9d649f0d3717f505f8437d65259df99b"
    sha256 cellar: :any,                 arm64_sonoma:  "b8fe0060668407937f504c6f64d9519ca85cd728162e9217c7feea45946a2a47"
    sha256 cellar: :any,                 sonoma:        "77f69a22a21a06e98ea9f03ec2c15bd4baaf4f59d198322c9d64bd4314cd5a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d15baedac0d5915f1a052b6fd5055f2d4d085d65b6b5500d2dbf2185c00783af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "794a2b79d84e067a17f0979d65d87762c23fbd45a1ec664c9c37fa232f5025fc"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
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
