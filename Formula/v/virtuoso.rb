class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.14/virtuoso-opensource-7.2.14.tar.gz"
  sha256 "c80e1a9fd114479e0588fc61de149c6e5b142d517ed92a2d64b22d5a88458a74"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e692694b4a2cff3fec3891040c0d7a6ca90d917267a5d8845d079d7e7a7993c"
    sha256 cellar: :any,                 arm64_sonoma:  "48d4b155bda7e3d1b76feed1dae6380a5ddf86828fe8d68c20c13a4e2c4cfe4a"
    sha256 cellar: :any,                 arm64_ventura: "ec1ba9dcf65b8306a7cf1355b9fdca4a36a2e4bbce092cf23be53a534e6b95d9"
    sha256 cellar: :any,                 sonoma:        "12e6d1230335e4c77fc52c31c3657cd31cb3cb6a6ad7e519c7e903a0522170a8"
    sha256 cellar: :any,                 ventura:       "97bb2a181efc5991b247244da81b046f3c51991f20a3523ce3140ad2a1bbfcf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b07c607f72b4b3954a9c13c97fa9d02ebebee1499d3a41fac32b79e5729bdfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3486ce694b17ad0decf53bb95f975885604623291f34076f7ea2922c3328d9b"
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
