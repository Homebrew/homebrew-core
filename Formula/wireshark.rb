class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.0.3.tar.bz2"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.0.3.tar.bz2"
  sha256 "e196376e75fe21fdef41b4eaa27ce2e1b2b561e7f7b20328a8e96657cc4465fc"
  revision 1

  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "031983c39798ac3ecd0378835ecd26713a347f690b8a63671367aa6f60928674" => :el_capitan
    sha256 "610d2fad4869846c74f9c439c8c11fa4ec62c127e6031cfef63f125f616a8057" => :yosemite
    sha256 "f381f463f840b1b7e09048bfd78e159d928dc4a4f826cc582dc1686f189d616c" => :mavericks
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
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
      tar zxvf ChmodBPF.tar.gz
      open ChmodBPF/Install\\ ChmodBPF.app

    This adds a launch daemon that changes the permissions of your BPF
    devices so that all users in the 'admin' group - all users with
    'Allow user to administer this computer' turned on - have both read
    and write access to those devices.

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
