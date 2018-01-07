class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "https://www.crosswire.org/sword/index.jsp"
  url "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.8/sword-1.8.0.tar.gz"
  sha256 "b5eba722c6c0b55c7931a48344ed1e12d8f5f6974e6b21686018250975f0f956"

  bottle do
    sha256 "0568345c99f0fbc799e7a5afb16322656ee790e5d8c63aa80e739cbe0c8e9711" => :high_sierra
    sha256 "e3522ab2b7c29cd8bdee6e8e7fafa464493375dd7018f5ff2f5a1f845a90b4e7" => :sierra
    sha256 "21cb37c91c8ad4b179bbdcaaac03789d4ee836f39f77f05fc6e667825766c2d9" => :el_capitan
  end

  option "with-clucene", "Use clucene for text searching capabilities"
  option "with-icu4c", "Use icu4c for unicode support"

  depends_on "clucene" => :optional
  depends_on "icu4c" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-profile
      --disable-tests
      --with-curl
    ]

    if build.with? "icu4c"
      args << "--with-icu"
    else
      args << "--without-icu"
    end

    if build.with? "clucene"
      args << "--with-clucene"
    else
      args << "--without-clucene"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # This will call sword's module manager to list remote sources.
    # It should just demonstrate that the lib was correctly installed
    # and can be used by frontends like installmgr.
    system "#{bin}/installmgr", "-s"
  end
end
