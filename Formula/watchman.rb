class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.05.31.00.tar.gz"
  sha256 "0bf447ba180bf7baecefcaa154eca73b0661b0b2c6162a8b010af8ef08e8ad18"
  license "Apache-2.0"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 arm64_big_sur: "4a44a39cfd719b34d146043aa5afcc6ac304ebbd2ff4ff0fb2e37e22871f38ac"
    sha256 big_sur:       "f03c91e17cd7595f98106ee4a27f28433ecc2fd6dde8cc1b7e279bd60b730051"
    sha256 catalina:      "30ed7115aa2a2534f5255508915f827c2e6f3100fcd7842415db64e31eabac30"
    sha256 mojave:        "135eb0a8f098417a8e4d67bf8d732a19bad1932eee085497877e93982e91074f"
    sha256 high_sierra:   "e872c3aae64c3b78197de9f12e272bebd5d20c316a120916f59a5f1cd2fac039"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.9"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre",
                          # Do homebrew specific Python installation below
                          "--without-python",
                          "--enable-statedir=#{var}/run/watchman"
    system "make"
    system "make", "install"

    # Homebrew specific python application installation
    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    cd "python" do
      system python3, *Language::Python.setup_install_args(libexec)
    end
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
    assert_equal(/(\d+\.\d+\.\d+)/.match(version)[0], shell_output("#{bin}/watchman -v").chomp)
  end
end
