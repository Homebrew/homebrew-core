class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.41.tgz"
  sha256 "bebdbe1e6e91233755beb42ef0b4adbefd9573455258f009fb331556c799b3d0"
  license "0BSD"

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a6fa3ce87975086eb2327e182c9e667c26f7b108ca55fae07d1395c234fcb41"
    sha256 cellar: :any,                 arm64_sequoia: "78007da0922ad1bb06ec75c05b9306fa3a52937245371c53e325c840f7f00891"
    sha256 cellar: :any,                 arm64_sonoma:  "12b7762dc18b71cd86b9bf7aa12fe0a4cbb4f4537e4072e66482039a7744cb06"
    sha256 cellar: :any,                 arm64_ventura: "7baebf33f0670c8fd4e3788599fa28a10c83a4be7ea0ddc1538cd48d68d58067"
    sha256 cellar: :any,                 sonoma:        "02a5c3c5a3c09a084eb4941fdc6cb74428011200705656ebae06386e92244f81"
    sha256 cellar: :any,                 ventura:       "a79d0a85059b11a514f05fcb0ae86faab0758983f2aa3280144761cfa1506f19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "668e24f0f0c50a92bc5a6800d3e74c5b162b51b3ced6e18b5cd9dd7570c2b89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00f951a9e99d1456f080c90c3a9bdbfedda1b04af93317daa3c67a71613cf4e"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "e2fsprogs" => :build
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
