class Twm < Formula
  desc "Tab Window Manager for X Window System"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/twm-1.0.12.tar.xz"
  sha256 "aaf201d4de04c1bb11eed93de4bee0147217b7bdf61b7b761a56b2fdc276afe4"
  license "X11"

  depends_on "pkg-config" => :build

  depends_on "libxmu"
  depends_on "libxrandr"

  uses_from_macos "bison" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    fork do
      exec bin/"twm"
    end
  end
end
