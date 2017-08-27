class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.4.0.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.4.0.tar.xz"
  sha256 "890bb41b826ff04e98fb089446ab37e5871e16205278bfeffc2a7c7364de3b04"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "c5cfda53d9caa6068b5246076279f877ee4dedd1b2eb5a077c47c9d082772904" => :sierra
    sha256 "5e31d7c3f31f4486127ecc37b98796eb492e507bdd47034ca39b9519b2eef836" => :el_capitan
    sha256 "62f239202d0356de0034367faa50af01505c7e42fad2b55b6a14235c4928a817" => :yosemite
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-gtk+3", "Build the wireshark command with gtk+3"
  option "with-gtk+", "Build the wireshark command with gtk+"
  option "without-qt", "Disable the Wireshark Qt GUI"
  option "with-headers", "Install Wireshark library headers for plug-in development"

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "geoip" => :recommended
  depends_on "c-ares" => :recommended
  depends_on "libsmi" => :optional
  depends_on "lua" => :recommended
  depends_on "portaudio" => :optional
  depends_on "qt" => :recommended
  depends_on "gtk+3" => :optional
  depends_on "gtk+" => :optional
  depends_on "libssh" => :optional
  depends_on "nghttp2" => :optional
  depends_on "lz4" => :optional
  depends_on "snappy" => :optional
  depends_on "spandsp" => :optional
  depends_on "gnome-icon-theme" if build.with? "gtk+3"

  # Fix build due to missing source file (will be fixed in 2.4.1)
  resource "udpdump.pod" do
    url "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;hb=v2.4.0;f=doc/udpdump.pod"
    sha256 "4f2a6f7c0f39793c9bf14db5563fc284275a342677aeaef02d91a3980a5c37d1"
  end

  def install
    # Disable nghttp2 if requested (remove this for 2.4.1)
    inreplace "CMakeLists.txt", /(set\(PACKAGELIST.*) NGHTTP2/, '\1' unless build.with?("nghttp2")

    # Install missing udpdump.pod source file in srcdir (remove this for v2.4.1).
    resource("udpdump.pod").stage(buildpath/"doc")

    args = std_cmake_args
    args << "-DENABLE_GNUTLS=ON"

    if build.with? "qt"
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
      args << "-DENABLE_QT5=OFF"
    end

    if build.with?("gtk+3") || build.with?("gtk+")
      args << "-DBUILD_wireshark_gtk=ON"
      args << "-DENABLE_GTK3=" + (build.with?("gtk+3") ? "ON" : "OFF")
      args << "-DENABLE_PORTAUDIO=ON" if build.with? "portaudio"
    else
      args << "-DBUILD_wireshark_gtk=OFF"
      args << "-DENABLE_PORTAUDIO=OFF"
    end

    args << "-DBUILD_sshdump=" + (build.with?("libssh") ? "ON" : "OFF")
    args << "-DBUILD_ciscodump=" + (build.with?("libssh") ? "ON" : "OFF")

    args << "-DENABLE_GEOIP=" + (build.with?("geoip") ? "ON" : "OFF")
    args << "-DENABLE_CARES=" + (build.with?("c-ares") ? "ON" : "OFF")
    args << "-DENABLE_SMI=" + (build.with?("libsmi") ? "ON" : "OFF")
    args << "-DENABLE_LUA=" + (build.with?("lua") ? "ON" : "OFF")
    args << "-DENABLE_NGHTTP2=" + (build.with?("nghttp2") ? "ON" : "OFF")
    args << "-DENABLE_LZ4=" + (build.with?("lz4") ? "ON" : "OFF")
    args << "-DENABLE_SNAPPY=" + (build.with?("snappy") ? "ON" : "OFF")
    args << "-DENABLE_SPANDSP=" + (build.with?("spandsp") ? "ON" : "OFF")

    system "cmake", *args
    system "make"
    system "make", "install"

    if build.with? "qt"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark" => "wireshark"
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
