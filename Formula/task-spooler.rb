class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "http://vicerveza.homeunix.net/~viric/soft/ts/"
  url "http://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0731e16f98483ad9cc2dddba0895fcaa1ace8cb78102fb108b84dc39ea33298" => :high_sierra
    sha256 "4e40910e93dbad52616762c4fd85eaa2ffe7f8c75c769f3d5c81ff2115b22869" => :sierra
    sha256 "2d54706f5ac7cd1f0ab18af122223fb63960cb04da9effb3100fb4e1c53fc891" => :el_capitan
    sha256 "bda2858d1071b3091c48b9774786c3b88b0ded7cb7a569054aa1774b141e5555" => :yosemite
    sha256 "48fec6fbf078cffbc77ad1a5f7eaa01ca28561efbd5d847957bdf574bbb6c8fe" => :mavericks
    sha256 "00fdb36feaadc5c6f552318cf7e3aed402b1c49ffde203652a0eb0ccf4ffec8b" => :mountain_lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
