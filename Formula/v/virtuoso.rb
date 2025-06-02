class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.15/virtuoso-opensource-7.2.15.tar.gz"
  sha256 "e0b6dbcf09b58f30a4205c41041daa4050e00af1474e3d5e3ab3fcce5b9be6db"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "348d6bee110dc480ee50e75b459caebce403b6eaf41e10c5ede5f5f75c3a4984"
    sha256 cellar: :any,                 arm64_sonoma:  "f300dab174cc53b30883e3927d7cc740bae1b116b69812bafb13891f1ef11622"
    sha256 cellar: :any,                 arm64_ventura: "25176e4f349710ae8638a0fab1260738b0e714b7745e98cbc9afab419a606832"
    sha256 cellar: :any,                 sonoma:        "4e84d100192db0bb7696fdc6fd4df9e3aedeb5d36bbf879ee1c6fd245de7a14e"
    sha256 cellar: :any,                 ventura:       "9988e7ced301bb8e37f9ce0774939e4c95ebd96be84fc8e14cab61dc4908c739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09b2fb4441d2a1e13502113f3382eb3f8b4d6eae7a0a82d8cae3b785322462eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05367d620bd9173ccdbd871caba54b2bfc50aaabafaa2640d1771adbce9ff3dd"
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
