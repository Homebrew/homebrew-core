class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  revision 1
  head "https://github.com/Andersbakken/rtags.git"

  stable do
    url "https://github.com/Andersbakken/rtags.git",
        :tag => "v2.8",
        :revision => "6ac7740eaf05cdd9b699185f71cc2d1f634a761b"

    # Fix test failure "couldn't find process for pid"
    # Upstream commit from 4 Jan 2017 "Copy environment from indexmessage"
    patch do
      url "https://github.com/Andersbakken/rtags/commit/cddf96a.patch"
      sha256 "c7d2c62cba6ef8180ac6214af6dfdf2d0f6425b9453de7b55053ddcc74ce5fe2"
    end
  end

  bottle do
    sha256 "3e2649ceda64ae71a42c1907c34ba186b9b6937faaee13cec239c60f134c30f7" => :sierra
    sha256 "c221421644f29d5f2680d7fe6375d6c7c46f2b4eeb5665707ca29a26541cf50e" => :el_capitan
    sha256 "d875068e438884f4166a7a859fad9affbcb7a12c4164df38277fd548e6dc203b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "openssl"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    args = std_cmake_args << "-DRTAGS_NO_BUILD_CLANG=ON"

    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DHAVE_CLOCK_MONOTONIC_RAW:INTERNAL=0"
      args << "-DHAVE_CLOCK_MONOTONIC:INTERNAL=0"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/bin/rdm --verbose --inactivity-timeout=300 --log-file=#{HOMEBREW_PREFIX}/var/log/rtags.log"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/rdm</string>
        <string>--verbose</string>
        <string>--launchd</string>
        <string>--inactivity-timeout=300</string>
        <string>--log-file=#{var}/log/rtags.log</string>
      </array>
      <key>Sockets</key>
      <dict>
        <key>Listener</key>
        <dict>
          <key>SockPathName</key>
          <string>#{ENV["HOME"]}/.rdm</string>
        </dict>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<-EOS.undent
        void zaphod() {
        }

        void beeblebrox() {
          zaphod();
        }
    EOS
    (testpath/"src/README").write <<-EOS.undent
        42
    EOS

    rdm = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system "#{bin}/rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
