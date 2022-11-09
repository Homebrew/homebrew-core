class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.8/virtuoso-opensource-7.2.8.tar.gz"
  sha256 "979d221d1ddeb7898db0a928ad883897d9ddcd39886a54042fae9a9b9b551bfa"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58ad935254f290f7e50a5ffce7560a52020c366cb5cb486e039fd30f45941890"
    sha256 cellar: :any,                 arm64_monterey: "a6aca0e48229e1f7758e5cb676876faac4e8866a94d1e0c13ba64fee14776895"
    sha256 cellar: :any,                 arm64_big_sur:  "9e6b80ef1795a03f3e857d495c8f88cc0badc0860e8c337478672f28a90573ce"
    sha256 cellar: :any,                 monterey:       "3cc49b38a93736781daef10bb283fff16dc6dd9491a415ac452e260bb1ac10ef"
    sha256 cellar: :any,                 big_sur:        "1f84117306bcf67c000a6ebc460e449ec510cf30203bc4f50035aadb229d80cf"
    sha256 cellar: :any,                 catalina:       "8d64e4a3e591c41076a7c145699a3f6be6f031b240c1058e4588408b10006551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "030d688ffd43f34d323f59686b98da19a90c424e8ab7826b1d2c3066142fbe69"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-internal-zlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
