class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "944bc0e4812e61b2b7c4cd17b1b37b41325deffa0b84192aff8c0eace1a5da4c"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cbcb757ff9be891e15c6f7d0cdae25a65edd84356cc0c2762d56a73d2fca45d8"
    sha256 arm64_sequoia: "76c14a9650e463ea35aefd0e09e459bf675656d90e413266be8633dbc6a3bb6f"
    sha256 arm64_sonoma:  "9c9130f7da8da6d0e0208a3ae152e240d0ec49402c96833548e01fc3ebde26f6"
    sha256 arm64_ventura: "173c7b946ed5a9b59f4bfe77ffedd5d2f8c3319dc23fba0213c2e6864833a2bc"
    sha256 sonoma:        "04e97f15e237b8bba5503e37ae068fea5e19bc270212dc5fd90d2d3b998f4ae4"
    sha256 ventura:       "0ef750a1247f43d8781c95f655f8ece83e2f401f41dca53b6421b2b80d99f8d5"
    sha256 arm64_linux:   "4dc693d78c25778cb5bb669c0792fbbbede81d1779691de52e19eed3b9c6b36b"
    sha256 x86_64_linux:  "d8872767bff66175ea7bdcc9654489ad2f285a6a8f4e7fb32f237f575ec93e59"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    # TODO: add `libptytty` as a formula, there is a fallback for now
    system "./configure", "--without-libptytty", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rlwrap", "--version"
  end
end
