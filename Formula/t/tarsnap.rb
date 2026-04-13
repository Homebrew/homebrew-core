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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ca2b3013ba1c54f48150e5d0e7e14319e34c30dab2672ed07e5ed0ae892094a5"
    sha256 cellar: :any,                 arm64_sequoia: "4cb5837e33134878309495068c652e56eff9737952e1e3a55b6e8182170f0cb3"
    sha256 cellar: :any,                 arm64_sonoma:  "9375a2dd6ebab4d05d7a6cd6aa64d9d044c9774924d60f81528788aa3cc32e1d"
    sha256 cellar: :any,                 sonoma:        "3304b5c996c73844068ad9baef54cb66f93cb30abed8da61d0e1f58794ca7ab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6439740896ab865ec1ea55f3f00522288cd72cd4eae4c0f563c784c783ab3b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7053a34f26dfd83767bf485f74fafcf8c48aefc7270c66461342d4f4f4a3db6a"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

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
