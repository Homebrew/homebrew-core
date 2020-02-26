class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.15/xapian-core-1.4.15.tar.xz"
  sha256 "b168e95918a01e014fb6a6cbce26e535f80da4d4791bfa5a0e0051fcb6f950ea"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "6c6664a6610f8825cc704392667de90e105a33f9713ba89816dd56dbb86f5ccf" => :catalina
    sha256 "d62e83d7e27525b93403a00257fc212cd4ea8d6ca55f034f15f1882d2fb0999c" => :mojave
    sha256 "e953ecc8f71b25029e6a1fa38346c56896fbe31de5371dfe4fcf2a1cd543d705" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.15/xapian-bindings-1.4.15.tar.xz"
    sha256 "68441612d87904a49066e5707a42cde171e4d423bf8ad23f3f6c04b8a9b2c40c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      ENV.prepend_create_path "PYTHON3_LIB", lib/"python3.7/site-packages"

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python3.7/site-packages"
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor/lib/python3.7/site-packages"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-python3"

      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system "python3", "-c", "import xapian"
  end
end
