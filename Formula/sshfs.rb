class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs_2.8/sshfs-2.8.tar.gz"
  sha256 "7f689174d02e6b7e2631306fda4fb8e6b4483102d1bce82b3cdafba33369ad22"

  option "without-sshnodelay", "Don't compile NODELAY workaround for ssh"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :osxfuse
  depends_on "glib"

  # Fixes issue https://github.com/libfuse/sshfs/issues/27
  patch do
    url "https://github.com/libfuse/sshfs/commit/e5acfce8eda218d.patch"
    sha256 "53b165353c944303d0839bbe1bf16c04eaaee2deca89ccff729b1974d14aa8cb"
  end

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
