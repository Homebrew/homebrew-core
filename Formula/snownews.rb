class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/kouya/snownews"
  url "https://github.com/kouya/snownews/archive/v1.5.13.tar.gz"
  sha256 "9a06cd58dee7846cbb18166c3b60153c1b7ee963261b205633d77feaa5410455"

  bottle do
    sha256 "22fb8c0d85ab994352f15a8a54418d8e50dbf30b418c0e16daf34a0522a5a99b" => :high_sierra
    sha256 "111d01a8162376cf510ca58d4db0dc87c3edd171f782738d36ce8326b25741f6" => :sierra
    sha256 "03ac9fea075ea76b934c2ff5365b5e48295c6fbcb03f9c402332bbdf5f84690b" => :el_capitan
    sha256 "9d950bf2641410e4ddc6646eeaead2e49a5925b186a7d72fb207f11ceaaa0572" => :yosemite
    sha256 "50505095e31d0c0a0960cae1abd00e8900c64967c5ad81068de161c510e59afe" => :mavericks
  end

  depends_on "gettext"
  depends_on "openssl"

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
