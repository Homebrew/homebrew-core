class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.7/virtuoso-opensource-7.2.7.tar.gz"
  sha256 "02480b930d5fb414cb328f10cfd200faa658adc10f9c68ef7034c6aa81a5a3a0"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c30c0e74ff6eabda834e2df9c46df1b201f759b94969c811a893a78549500383"
    sha256 cellar: :any,                 arm64_big_sur:  "4dca442e00b50e886d6fb23d6d58824a4d215611b9396c5816e30e335ef046ad"
    sha256 cellar: :any,                 monterey:       "b64f134ad74f950684c3ecc47ad1aaf7a29f2a9e8b93c32f662c809ffc16e86c"
    sha256 cellar: :any,                 big_sur:        "1dfdebfe41f249a57d48db33ba0a5f96a1c11671f720f0f33dbb20eb641f0a31"
    sha256 cellar: :any,                 catalina:       "7259a7caa010744dc03e8945fd05e6f96066206a5ff54f3471a67d31b5c4357f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "383edea95dbe7e7343f9ecea389d73f864ef13d978dd05dc1f9f9db06d485f7b"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "net-tools" => :build
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
