class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.2.8.tar.bz2"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.2.8.tar.bz2"
  sha256 "ecf02c148c9ab6e809026ad5743fe9be1739a9840ef6fece6837a7ddfbdf7edc"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "222222ac7bfc31a9b9b3022c2f88e578b41dd93c6bbc0c5ad8d5651701038489" => :sierra
    sha256 "e6f70edbd14b27790d2b854638d9741543dacd175f3a0081ff106068d1c61085" => :el_capitan
    sha256 "38f177e30b9fbe9d3f1cb826bd21b33327af3437c5414fd80155eceeb70d8d01" => :yosemite
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

  def install
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
