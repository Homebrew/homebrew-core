class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.9/virtuoso-opensource-7.2.9.tar.gz"
  sha256 "be838c623aa6f8a2e2ab90005e63f0ff1363d6fa8fa64b811caab71e3125ba90"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a75a905b4b13f3b24cfe575d0734a63c04647b03ba7e1688694f586ac3ea24a"
    sha256 cellar: :any,                 arm64_monterey: "f89bee2260392c6ae90fae32eaa6766682e0a82736a3af4d9afd6a6c846f9090"
    sha256 cellar: :any,                 arm64_big_sur:  "36f3e085d9425c3fb75d9472c8325abc0c127da0b370c61349caf966fef26137"
    sha256 cellar: :any,                 ventura:        "ecdc405773408b67d4cbc8fe37db34980801648ac12fcf0915a95f3acf026c28"
    sha256 cellar: :any,                 monterey:       "b18bc3c59f8b7af966fb7d59598e63c69dc7c650a2481b7d97e9ac38351751d5"
    sha256 cellar: :any,                 big_sur:        "b419fda92e6c0a9c1c12ae76c19b89be56d3161c73a632cd1c902ad74f00d6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3934550d620fa88613ab3592891dfd4277f7dee120fa6f0bfaa6eee49e7a55"
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
