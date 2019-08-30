class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/kouya/snownews"
  url "https://github.com/kouya/snownews/archive/v1.5.13.tar.gz"
  sha256 "9a06cd58dee7846cbb18166c3b60153c1b7ee963261b205633d77feaa5410455"
  revision 1

  bottle do
    sha256 "3a89fb71e6e5a5aecc6dc3eaa1e13e88a3d7f5a6525bb92f367b6e064de8a930" => :mojave
    sha256 "bd80fc41d335b08d8fa9d1a318c1bcfc89493f39d9fad1c4135d2f763ef16a41" => :high_sierra
    sha256 "c2e3fdc0f474a67399f3fcf6934d97b7194209e2a97aab348768edd5b30c74e1" => :sierra
  end

  depends_on "gettext"
  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "./configure", "--prefix=#{prefix}"

    # Must supply -lz because configure relies on "xml2-config --libs"
    # for it, which doesn't work on OS X prior to 10.11
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags} -L#{Formula["openssl"].opt_lib} -lz", "CC=#{ENV.cc}"
  end
end
