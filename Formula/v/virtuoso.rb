class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.17/virtuoso-opensource-7.2.17.tar.gz"
  sha256 "41e0afd6d37c1c41b993282ce11c5cf68f7bb7c0bd7887ef2ff558c452570216"
  license "GPL-2.0-only" => { with: "x11vnc-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8710e5d0b65eaf9dc44253015f08bcae16225aad0f1dd4ee38cbe27d8da45428"
    sha256 cellar: :any,                 arm64_sequoia: "34460ec8da9cdde5e97f8b6a22ffe3a012b5cbcac6b634311d334ae9dcc41028"
    sha256 cellar: :any,                 arm64_sonoma:  "2bfd02d4134c88e5f6868edb3da655eab9b4a9b22d5497a80d2a6466cc863346"
    sha256 cellar: :any,                 sonoma:        "6ec3a63dcfd8990dc011a9586a760a2c9edc6331e5b7866b4ddf6b932c99a860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885da47f3af531200f9cd16bc76fbd7c2aa5d3605bb1451478deac4f4c59b4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b4dd1d9625820b51ddb3212907de9bff810167d46fa3395bfd2b0d6fed06a3"
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
