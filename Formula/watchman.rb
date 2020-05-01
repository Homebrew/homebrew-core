class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  revision 4
  head "https://github.com/facebook/watchman.git"

  stable do
    url "https://github.com/facebook/watchman/archive/v4.9.0.tar.gz"
    sha256 "1f6402dc70b1d056fffc3748f2fdcecff730d8843bb6936de395b3443ce05322"

    # Upstream commit from 1 Sep 2017: "Have bin scripts use iter() method for python3"
    patch do
      url "https://github.com/facebook/watchman/commit/17958f7d.diff?full_index=1"
      sha256 "edad4971fceed2aecfa2b9c3e8e22c455bfa073732a3a0c77b030e506ee860af"
    end
  end

  bottle do
    sha256 "7c01f1d4e6e8c15ec4d3625520b7e43e245d22f33ce7319dc962b7cb0b9b3d5d" => :catalina
    sha256 "a9b3039561abdde021ba080ee1e37984f7f56184476a4ffee1db476561f92d83" => :mojave
    sha256 "158a3dcce76f01446c9264a6f623a1c6be339118760ce61d88a9d38e2676ad45" => :high_sierra
    sha256 "013faefc9001613c58680e5626b36fe943ca943649882054fbfbefccf4796415" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :macos => :yosemite # older versions don't support fstatat(2)
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.8"

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
    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    cd "python" do
      system python3, *Language::Python.setup_install_args(libexec)
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
