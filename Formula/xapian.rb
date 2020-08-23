class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.16/xapian-core-1.4.16.tar.xz"
  sha256 "4937f2f49ff27e39a42150e928c8b45877b0bf456510f0785f50159a5cb6bf70"
  license "GPL-2.0"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "d40ce12010e79a967378d80c2583400447c45b4a1ee48643b46a9775c5bc72ef" => :catalina
    sha256 "aa6b6dfdc248b246bae4526a7c4bfb50a1b1e43a9ab9afb2ef37b3b335fd88cd" => :mojave
    sha256 "927e056162df124b23a9a0e492368ca5047f25b6d1b0eb887fc84d723a71ba2d" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.8"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.16/xapian-bindings-1.4.16.tar.xz"
    sha256 "8791ec6d15cdd2fa065e414033d0b1cd5cf61916fdb47ae5d36c3dfe69be621b"
  end

  def install
    python = Formula["python@3.8"].opt_bin/"python3"
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
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import xapian"
  end
end
