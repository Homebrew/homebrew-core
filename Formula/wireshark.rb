class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.2.6.tar.bz2"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.2.6.tar.bz2"
  sha256 "f627d51eda85f5ae5f5c8c9fc1f6539ffc2a270dd7500dc7f67490a8534ca849"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "522111fc9df2a5f6e60f464ca67bd5a60387d7369c03e9d626d2732f8e66714b" => :sierra
    sha256 "e610c5ecc9296423c2fbc66cb78e65c4c69a7159f8d8f36c727e1bd18fa81e5e" => :el_capitan
    sha256 "50d9c288babdada6ee13d27eec4e9e365b8ca5a67149960199f9f6e86e05517d" => :yosemite
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-gtk+3", "Build the wireshark command with gtk+3"
  option "with-gtk+", "Build the wireshark command with gtk+"
  option "with-qt", "Build the wireshark command with Qt (can be used with or without either GTK option)"
  option "with-headers", "Install Wireshark library headers for plug-in development"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "dbus"
  depends_on "geoip" => :recommended
  depends_on "c-ares" => :recommended
  depends_on "libsmi" => :optional
  depends_on "lua" => :optional
  depends_on "portaudio" => :optional
  depends_on "qt" => :optional
  depends_on "gtk+3" => :optional
  depends_on "gtk+" => :optional
  depends_on "gnome-icon-theme" if build.with? "gtk+3"

  # 2017-04-14 set fossies as main url due to tcpdump connection issues
  resource "libpcap" do
    url "https://fossies.org/linux/misc/libpcap-1.8.1.tar.gz"
    mirror "http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz"
    sha256 "673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"
  end

  def install
    if MacOS.version <= :mavericks
      resource("libpcap").stage do
        system "./configure", "--prefix=#{libexec}/vendor",
                              "--enable-ipv6",
                              "--disable-universal"
        system "make", "install"
      end
      ENV.prepend_path "PATH", libexec/"vendor/bin"
      ENV.prepend "CFLAGS", "-I#{libexec}/vendor/include"
      ENV.prepend "LDFLAGS", "-L#{libexec}/vendor/lib"
    end

    args = std_cmake_args
    args << "-DENABLE_GNUTLS=ON" << "-DENABLE_GCRYPT=ON"

    if build.with? "qt"
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
    end

    if build.with?("gtk+3") || build.with?("gtk+")
      args << "-DBUILD_wireshark_gtk=ON"
      args << "-DENABLE_GTK3=" + (build.with?("gtk+3") ? "ON" : "OFF")
      args << "-DENABLE_PORTAUDIO=ON" if build.with? "portaudio"
    else
      args << "-DBUILD_wireshark_gtk=OFF"
      args << "-DENABLE_PORTAUDIO=OFF"
    end

    if build.with? "geoip"
      args << "-DENABLE_GEOIP=ON"
    else
      args << "-DENABLE_GEOIP=OFF"
    end

    if build.with? "c-ares"
      args << "-DENABLE_CARES=ON"
    else
      args << "-DENABLE_CARES=OFF"
    end

    if build.with? "libsmi"
      args << "-DENABLE_SMI=ON"
    else
      args << "-DENABLE_SMI=OFF"
    end

    if build.with? "lua"
      args << "-DENABLE_LUA=ON"
    else
      args << "-DENABLE_LUA=OFF"
    end

    system "cmake", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make", "install"

    if build.with? "qt"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark"
    end

    if build.with? "headers"
      (include/"wireshark").install Dir["*.h"]
      (include/"wireshark/epan").install Dir["epan/*.h"]
      (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
      (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
      (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
      (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
      (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
      (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
      (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
    end
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default macOS behavior), try installing ChmodBPF from homebrew cask:

      brew cask install wireshark-chmodbpf

    This creates an 'access_bpf' group and adds a launch daemon that changes the
    permissions of your BPF devices so that all users in that group have both
    read and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
