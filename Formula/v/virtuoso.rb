class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.13/virtuoso-opensource-7.2.13.tar.gz"
  sha256 "7c138389fb412ca45935ab605daa16e96df1c11b67373a9b92f03c9fd6c35ec4"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1c07489e94dc7864ebac9cd3360b530aeb13d871ea3552c94caf86b8ece564a8"
    sha256 cellar: :any,                 arm64_sonoma:   "73ea2ae83de5dede38609a3bb93fbd170bfbc84ab81a46d3653704f546b84270"
    sha256 cellar: :any,                 arm64_ventura:  "aee80e84acb4348d360de4ec9d3fa868c5785983bc278d06cf25ac108493e564"
    sha256 cellar: :any,                 arm64_monterey: "67399c6e0e2f05a0474ba1687ad45d4a4a306c70cbe2a568f47ae33eece75b50"
    sha256 cellar: :any,                 sonoma:         "a73f74103ffb52c691aaf413358b04b389d325987e48fddfe13608c22d70f89d"
    sha256 cellar: :any,                 ventura:        "10938d0db150f8c612e6126f22b6b25bbaaf424c23d17cbf36dc4df6420c1ecc"
    sha256 cellar: :any,                 monterey:       "cb01a85ca94e9a63608653fa758453593081714f4a385f79d2e53c0bf4e889eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fc37ec8db10030a0acdbaea2185c30431936c16510ea6ba8efe0adc6c9a5ed"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3.0"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
    depends_on "xz" # for liblzma
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
