class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.6.tar.gz"
  sha256 "965e49b3e53f44023994b42b3aa568ad79d3a2287bb0a07460b601500c9ae16d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa693e01a17d31e9e5a5b51f27ea18b69e30f5613615c95ddb89c7dbc4bbe75d" => :sierra
    sha256 "3b6751d8a871e44c033e4a6d83009bb8b499952385d8c1743be3d26bfe37b312" => :el_capitan
    sha256 "d292048f1869507766d60e6931bffbf402f99d8fe36711ed6d9dbb060407a4a6" => :yosemite
  end

  # Patches to allow `make install` to specify a prefix; both patches
  # can be removed in the next release
  patch do
    url "https://gitlab.com/esr/wumpus/commit/ea272d4786a55dbaa493d016324b7a05b4f165b9.diff"
    sha256 "9a6d625e10425674329f14c625dba43b78b66c8137d356453d021e6c39ec339b"
  end
  patch do
    url "https://gitlab.com/esr/wumpus/commit/99022db86e54c3338d6a670f219a0845fd531530.diff"
    sha256 "72e40a834eb87e8deef51e8f064c50d93880e85ff9904a50be6b7c85052cc157"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match("HUNT THE WUMPUS",
                 pipe_output(bin/"wumpus", "^C"))
  end
end
