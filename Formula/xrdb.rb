class Xrdb < Formula
  desc "X resource database utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrdb"
  url "https://www.x.org/releases/individual/app/xrdb-1.2.1.tar.bz2"
  sha256 "4f5d031c214ffb88a42ae7528492abde1178f5146351ceb3c05f3b8d5abee8b4"
  license "MIT-open-group"

  depends_on "pkg-config"  => :build
  depends_on "xorg-server" => :test

  depends_on "libxmu"

  def install
    configure_args = std_configure_args + %w[
      --with-cpp=/usr/bin/cpp
    ]
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    system bin/"xrdb", "-query"
  end
end
