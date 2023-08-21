class QuartzWm < Formula
  desc "XQuartz window-manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/quartz-wm"
  url "https://gitlab.freedesktop.org/xorg/app/quartz-wm/-/archive/babff9d70f61239c46c53a3e41ce10c7ca1419ce/quartz-wm-babff9d70f61239c46c53a3e41ce10c7ca1419ce.tar.bz2"
  version "1.3.2"
  sha256 "11a344d8ad9375b61461f0e90b465bc569e60ce973f78e84d3476e7542065be0"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a6c735c400154429cb612b7886bdcab1337a7e1b65e2c94a14bef1404e6aa4dd"
    sha256 cellar: :any, arm64_monterey: "cabeb2c482930b2f1e03a6328659546bd6847497a56c838f48efb86678cf798b"
    sha256 cellar: :any, arm64_big_sur:  "b0cdccaa2c76e580c9d35c2a75c459e965254f226e635d3951f4b20b228fbd44"
    sha256 cellar: :any, ventura:        "b994c864513fbfab4728a5b3cb3b26c69072a1c82d3140908ed7bde34df56b37"
    sha256 cellar: :any, monterey:       "8107b0c85a02432912e041960e1f3ec1096bdf46ca876a696550a98b645ade00"
    sha256 cellar: :any, big_sur:        "4d0abe6b48b2ce5ee2c6c44c3c7af67201f0df90b2fe7d75e9273238df19fdce"
  end

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
