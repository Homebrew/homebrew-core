class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  license "GPL-2.0-only" => { with: "x11vnc-openssl-exception" }

  stable do
    url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.17/virtuoso-opensource-7.2.17.tar.gz"
    sha256 "41e0afd6d37c1c41b993282ce11c5cf68f7bb7c0bd7887ef2ff558c452570216"

    # Backport for OpenSSL 4 support
    patch do
      url "https://github.com/openlink/virtuoso-opensource/commit/8a6ae8fe8d93076ac151dffcfb4c5c1ecbd61860.patch?full_index=1"
      sha256 "12d8e6e18d22153b91d1eeac111a071b0e067b6fe8338867b70ebf79271fdca2"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3b6bc9a6c291d222e83fa65a6bfd9dc13f0b808c5307b22d0de497ff6e3d670d"
    sha256 cellar: :any, arm64_tahoe:       "a01d634fc0a122c2e133dcfb55143d72a2c34b861133061604772f792d0cf46f"
    sha256 cellar: :any, arm64_sequoia:     "a4378e99e79e94f8f373027cdb1f9c682dc6277f8d7eb8b9748e67d284e2dd63"
    sha256 cellar: :any, arm64_linux:       "7c11994fb8bf5f06fca3bf50b5059173b8ef9a5faf57efc1fa4073190bfe7970"
    sha256 cellar: :any, x86_64_linux:      "c6b665b0b846ddf64865d1734b8b06526349e8ff6a8455d4df38d3e85702874f"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "net-tools" => :build
    depends_on "xz" # for liblzma
    depends_on "zlib-ng-compat"
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?

    # Ignore overly restrictive OpenSSL upper bound check. Same as Debian patch:
    # https://sources.debian.org/patches/virtuoso-opensource/7.2.12+dfsg-2/openssl-upper-bound.patch/
    # Can be removed if upstream allows version of OpenSSL we want
    inreplace "configure", "#error OpenSSL version too new", "//\\0"

    system "./configure", "--disable-silent-rules",
                          "--without-internal-zlib",
                          *std_configure_args
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
