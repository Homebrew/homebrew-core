class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.0.4.tar.bz2"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.0.4.tar.bz2"
  sha256 "9ea9c82da9942194ebc8fc5c951a02e6d179afa7472cb6d96ca76154510de1a5"

  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "0f7385bfd31d50c49d428c4d1d48f77c0d1ea7d2bd8805c7484e7134a7a4c29e" => :el_capitan
    sha256 "e144d712a4aa9c38b3a4b0d4cd6161af7ac267b3702bf4d0cf35edadb3a580fa" => :yosemite
    sha256 "97b8caa741f6697e5cec8ddbf5d136a358c2c22be6f501fcaf9a8d3f1da417e9" => :mavericks
  end

  option "with-gtk+3", "Build the wireshark command with gtk+3"
  option "with-gtk+", "Build the wireshark command with gtk+"
  option "with-qt", "Build the wireshark-qt command (can be used with or without either GTK option)"
  option "with-qt5", "Build the wireshark-qt command with qt5 (can be used with or without either GTK option)"
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
  depends_on "qt5" => :optional
  depends_on "qt" => :optional
  depends_on "gtk+3" => :optional
  depends_on "gtk+" => :optional
  depends_on "gnome-icon-theme" if build.with? "gtk+3"

  resource "libpcap" do
    url "http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz"
    sha256 "7ad3112187e88328b85e46dce7a9b949632af18ee74d97ffc3f2b41fe7f448b0"
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

    if build.with?("qt") || build.with?("qt5")
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=" + ((build.with? "qt5") ? "ON" : "OFF")
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
    end

    if build.with?("gtk+3") || build.with?("gtk+")
      args << "-DBUILD_wireshark_gtk=ON"
      args << "-DENABLE_GTK3=" + ((build.with? "gtk+3") ? "ON" : "OFF")
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

    if build.with?("qt") || build.with?("qt5")
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
    (default OS X behavior), try installing ChmodBPF from homebrew cask:

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
