class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-2.9/sshfs-2.9.tar.gz"
  sha256 "46d1e1287ce97255fcb50010355184d8c5585329f73ab1e755217419a8e6e5de"

  bottle do
    cellar :any
    sha256 "e1f2ea35bc0a40e43a803f9b4469d77094ff4abfdbb52db4e836d45e13adf924" => :sierra
    sha256 "1ca7bbe7e75f714ead1f2e23b6c3c4c2ede8315a99623837b31110aa855186f7" => :el_capitan
    sha256 "90a1d7b12563a40f21dfd452143da17bff82562b17b8881d7c2d02acc0680149" => :yosemite
  end

  option "without-sshnodelay", "Don't compile NODELAY workaround for ssh"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :osxfuse
  depends_on "glib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-sshnodelay" if build.without? "sshnodelay"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
