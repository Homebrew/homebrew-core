class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta/archive/v3.1.0.tar.gz"
  sha256 "7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d"

  bottle do
    cellar :any
    sha256 "7f51b76d06a6ac8aae36c10b41776a374d5fafa6b55c4908a885be7a88194676" => :sierra
    sha256 "e07f928aadf6a9d8beb8a19fb72cb673cf0ae13c339ccd75c5df134cb3bc5c09" => :el_capitan
    sha256 "2581a9d0aabf6f6b34d35aae4d7ab07b6aaebdb70fd3b00ef14eff3bd96aa6c7" => :yosemite
    sha256 "a0801a8bd9796d03d8c031905e28a6e5f50b155da3102337070ec787ccb5cee9" => :mavericks
  end

  option "without-xz", "Disable LZMA secondary compression"

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "xz" => :recommended

  def install
    cd "xdelta3" do
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
      ]

      if build.with? "xz"
        args << "--with-liblzma"
      else
        args << "--with-liblzma=no"
      end

      system "autoreconf", "--install"
      system "./configure", *args
      system "make", "install"
    end
  end

  test do
    system bin/"xdelta3", "config"
  end
end
