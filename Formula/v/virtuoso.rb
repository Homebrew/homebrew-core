class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.10/virtuoso-opensource-7.2.10.tar.gz"
  sha256 "c02b0a966ff33f854a86f8f74caa8a5a957e22b510cc2f808e54ed34b4b27f0f"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30a958c57c5828196fea11d6a7007372ab6b6ed87b4c88445dc1d34f0dd2122c"
    sha256 cellar: :any,                 arm64_monterey: "7c91c948a901aa4964056ec9c4b4c02e183374b0585a279e458f93741fee2131"
    sha256 cellar: :any,                 arm64_big_sur:  "320333e84c2aa9de2426911c9f64259d688af4303570e916c0a4f3b4df25d242"
    sha256 cellar: :any,                 ventura:        "9e5ee8a3b207ee447c5067fe8b65db020d417411b67e071a7cfbbd99c120567f"
    sha256 cellar: :any,                 monterey:       "97a6d7ce2aea3606ebc356e8924fdad8259e77670fc22572548dbfa55ad3663e"
    sha256 cellar: :any,                 big_sur:        "6c836fb0d288edeb325ec0105b6c7f1ca8db9980d49e209f7787203227e4bb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cbaa8d9809b82ac0ceb798d023c37c7d58d87bf4e7c01e9653a17fdcc032095"
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
