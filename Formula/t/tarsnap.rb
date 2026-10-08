class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.41.tgz"
  sha256 "bebdbe1e6e91233755beb42ef0b4adbefd9573455258f009fb331556c799b3d0"
  license "0BSD"
  revision 1

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "edf38bffee38408a67cb3602464df3846aa647147b402f67d543f6cac9c2a694"
    sha256 cellar: :any, arm64_tahoe:       "88c8a369498d4e6b18cf3dcacd10b4854e04364e223db84f39de615866efc17c"
    sha256 cellar: :any, arm64_sequoia:     "f513c4189124d4f2e08b76d6aec73ce877e93c58a2726292a3abeaac9d0253a9"
    sha256 cellar: :any, arm64_linux:       "df6ca5ccd9adad2e6db4a96051fc308b0273c20e856ee5d36b028c2e240dbd2d"
    sha256 cellar: :any, x86_64_linux:      "f899cadade85f722572115bc7ba833f48c38b7ac3c9e6f6fb72638ebef6dd581"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@4"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "e2fsprogs" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
      --without-lzma
      --without-lzmadec
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
