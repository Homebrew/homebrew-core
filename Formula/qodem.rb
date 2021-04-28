class Qodem < Formula
  desc "Terminal emulator and BBS client"
  homepage "https://qodem.sourceforge.io/"
  url "https://github.com/klamonte/qodem/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "84aecd322839c615c6f465128ea3231163067606704f19ffa50e5d3481b6ff01"
  license :public_domain

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-gpm",
                          "--disable-sdl",
                          "--disable-serial",
                          "--disable-upnp",
                          "--disable-x11"
    system "make", "install"
  end

  test do
    system "#{bin}/qodem", "--exit-on-completion", "--capfile", testpath/"qodem.out", "uname"
    assert_match "Darwin", File.read(testpath/"qodem.out")
  end
end
