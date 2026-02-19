class QuartzWm < Formula
  desc "XQuartz window-manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/quartz-wm"
  url "https://gitlab.freedesktop.org/xorg/app/quartz-wm/-/archive/babff9d70f61239c46c53a3e41ce10c7ca1419ce/quartz-wm-babff9d70f61239c46c53a3e41ce10c7ca1419ce.tar.bz2"
  version "1.3.2"
  sha256 "11a344d8ad9375b61461f0e90b465bc569e60ce973f78e84d3476e7542065be0"
  license "APSL-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "06ea0e9f6b34bc42af50738f3d878afd8cd0ebbf1cb5df938fdd8b1295e9c965"
    sha256 cellar: :any, arm64_sequoia:  "4c47db2f95f422bf84be4900c8ed90c96f5337a34c0a6279f524b618671c2425"
    sha256 cellar: :any, arm64_sonoma:   "8383efc0dafe5d0f14b6dd255b3f4a336ff8b5ad347005fab412e0b466bf3253"
    sha256 cellar: :any, arm64_ventura:  "a6c735c400154429cb612b7886bdcab1337a7e1b65e2c94a14bef1404e6aa4dd"
    sha256 cellar: :any, arm64_monterey: "cabeb2c482930b2f1e03a6328659546bd6847497a56c838f48efb86678cf798b"
    sha256 cellar: :any, arm64_big_sur:  "b0cdccaa2c76e580c9d35c2a75c459e965254f226e635d3951f4b20b228fbd44"
    sha256 cellar: :any, sonoma:         "c4a725767d49a67ecd9b03c2916cc9dbaf7aaeee973d1342e93e0bf714fe50c8"
    sha256 cellar: :any, ventura:        "b994c864513fbfab4728a5b3cb3b26c69072a1c82d3140908ed7bde34df56b37"
    sha256 cellar: :any, monterey:       "8107b0c85a02432912e041960e1f3ec1096bdf46ca876a696550a98b645ade00"
    sha256 cellar: :any, big_sur:        "4d0abe6b48b2ce5ee2c6c44c3c7af67201f0df90b2fe7d75e9273238df19fdce"
  end

  depends_on "autoconf"    => :build
  depends_on "automake"    => :build
  depends_on "libtool"     => :build
  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build
  depends_on "xorg-server" => :test

  depends_on "libapplewm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on :macos
  depends_on "pixman"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-bundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    spawn Formula["xorg-server"].bin/"Xvfb", ":1"
    ENV["DISPLAY"] = ":1"
    sleep 10
    spawn bin/"quartz-wm"
  end
end
