class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org.ua/software/rush/"
  url "https://ftpmirror.gnu.org/gnu/rush/rush-2.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rush/rush-2.4.tar.xz"
  sha256 "fa95af9d2c7b635581841cc27a1d27af611f60dd962113a93d23a8874aa060f4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:    "949f479b1e1d414b24cff1c6fe3b9b487308b0099b26e4b0268858c6bb403c6d"
    sha256 arm64_sequoia:  "8b4382d4d29a8b19f80b688720739341a2c50327fdac6f779110133a15df8137"
    sha256 arm64_sonoma:   "ec78d74a408de6970e3118681a3e98cae4814bfddc72d4bb3007beb96b14ea41"
    sha256 arm64_ventura:  "b0f7e7ad946f985563b45dca5fefbd157debead3b3c3464e8c845e31486e89eb"
    sha256 arm64_monterey: "ce2e49831215279a9e0a8dd96d019d4d208ffe623757c7b05a2fe5ac535aff2a"
    sha256 sonoma:         "47ccedc93f002ed994d2652677684e49c0ff84c6d416f70aa8e044a90cfb85e5"
    sha256 ventura:        "26c5ec15c485d6354de3eb4c340fe696ee30acd720049df938eeda46485bfd3b"
    sha256 monterey:       "daae369d6a80b9c625ba8decada43cfa076ca95db9dedc8d2ffb97694cc76b14"
    sha256 arm64_linux:    "b72e4b69ed5653be379a5a3d06f14b504c3d256835381a080805187facd76e61"
    sha256 x86_64_linux:   "2baf1eb74c5f83444259df516ed8983cc827e15a1c70827690ff0349bb5f7cbd"
  end

  conflicts_with "rush-parallel", because: "both install `rush` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
