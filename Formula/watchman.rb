class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.9.0.tar.gz"
  sha256 "1f6402dc70b1d056fffc3748f2fdcecff730d8843bb6936de395b3443ce05322"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "41484c1bd9660d1dc3a269da0f604ae4e4358861a7d6da7e217840a8e60973f8" => :high_sierra
    sha256 "d42c5a991e4cddef004773474b3d28f3275113a6c1858d0ddaae274a11bbeb33" => :sierra
    sha256 "83db75e3e7b186521d4b910a49836ec53ec85b987b6b35d63bc32b7282209dc7" => :el_capitan
    sha256 "da774a8464b5ddab2342d7d8ba0211220cd630d8099b2605bc977a4574dfee1e" => :yosemite
  end

  depends_on :macos => :yosemite # older versions don't support fstatat(2)
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre",
                          # we'll do the homebrew specific python
                          # installation below
                          "--without-python",
                          "--enable-statedir=#{var}/run/watchman"
    system "make"
    system "make", "install"

    # Homebrew specific python application installation
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    cd "python" do
      system "python", *Language::Python.setup_install_args(libexec)
    end
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
    # Older versions would use socket activation in the launchd.plist, and since
    # the homebrew paths are versioned, this meant that launchd would continue
    # to reference the old version of the binary after upgrading.
    # https://github.com/facebook/watchman/issues/358
    # To help swing folks from an older version to newer versions, force unloading
    # the plist here.  This is needed even if someone wanted to add brew services
    # support; while there are still folks with watchman <4.8 this is still an
    # upgrade concern.
    home = ENV["HOME"]
    system "launchctl", "unload",
           "-F", "#{home}/Library/LaunchAgents/com.github.facebook.watchman.plist"
  end

  test do
    assert_equal /(\d+\.\d+\.\d+)/.match(version)[0], shell_output("#{bin}/watchman -v").chomp
  end
end
