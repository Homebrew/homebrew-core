class QuartzWm < Formula
  desc "XQuartz window-manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/quartz-wm"
  url "https://gitlab.freedesktop.org/xorg/app/quartz-wm/-/archive/babff9d70f61239c46c53a3e41ce10c7ca1419ce/quartz-wm-babff9d70f61239c46c53a3e41ce10c7ca1419ce.tar.bz2"
  version "1.3.2"
  sha256 "11a344d8ad9375b61461f0e90b465bc569e60ce973f78e84d3476e7542065be0"
  license "APSL-2.0"

  depends_on "autoconf"    => :build
  depends_on "automake"    => :build
  depends_on "libtool"     => :build
  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorg-server" => :test

  depends_on "libapplewm"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on :macos
  depends_on "pixman"

  def install
    configure_args = std_configure_args + %W[
      --with-bundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
    ]

    system "autoreconf", "-i"
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
    fork do
      exec bin/"quartz-wm"
    end
  end
end
