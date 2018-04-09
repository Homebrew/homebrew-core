class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.tar.xz"
  sha256 "6c7397abc764e32e8159c2e96042874a190303e77adceb4ac5bd502a272a4734"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-ipcs",     # does not build on macOS
                          "--disable-ipcrm",    # does not build on macOS
                          "--disable-wall",     # already comes with macOS
                          "--disable-libuuid"   # conflicts with ossp-uuid

    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
