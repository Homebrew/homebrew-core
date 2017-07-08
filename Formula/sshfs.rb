class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-3.0.0/sshfs-3.0.0.tar.gz"
  sha256 "644966c7326c1b788a80318c5806f20f6d42dd72ab686f66d6120bd108b54d2d"

  bottle do
    cellar :any
    sha256 "bcbf5da34a36c42fdc495f13eef2e6393c7c8269082ad47a33ba8de3762472d4" => :sierra
    sha256 "eac485f8d8d5b5d04905eed01f82b1436f6fea5d658dd2af1603ffb8381536d7" => :el_capitan
    sha256 "7e2f3a208e10a8c05a2183e2bb251e191b5b66d11d8c4f8f09569d9bd7325fdc" => :yosemite
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
