class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.5.0",
      revision: "ca2fb06059c15442cb4c9a8c89de1a8fc3579a39"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4c55b1f92a877b592994d808cb2ad4e5562fe53684434469a9975f4d3d1a7f3c"
    sha256 cellar: :any,                 arm64_big_sur:  "3ea5f35da2f08549ae689176f80bbaa094de9d7f150c6e84dde12f31638918ec"
    sha256 cellar: :any,                 ventura:        "a5434f2ad715afd64b81c2b44fec58da3cdf6e034c13ad88f2f725cb834cb6a8"
    sha256 cellar: :any,                 monterey:       "bc62a5747f41ae8aa3fbbb669a59c42036e95e858ca1766f9846496f11944968"
    sha256 cellar: :any,                 big_sur:        "b6367ac81891a77cbc2dcbaa4698bfb9aca03dccac7ae17e6e19aed49892a424"
    sha256 cellar: :any,                 catalina:       "0ca7388d9c523d084635ad9d94aaafdfa6d8c87e90c9c15ff06aca39285d8f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4693307b48dadaf39e0becd4d6dba54efdd662014e29658bbc3046a6f7f1b3da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "test",
      "'[herder],[upgrades],[accountsubentriescount]," \
      "[bucketlistconsistent],[topology]'"
  end
end
