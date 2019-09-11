class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      :tag      => "v2.33",
      :revision => "a5fa0951c92b4e5423d4ce95adafdca6ea30f254"
  revision 2
  head "https://github.com/Andersbakken/rtags.git"

  bottle do
    cellar :any
    sha256 "8499bfca6f3896c57209ffd87ce5f5e119cb212a29397db616eb6153ecd1f547" => :mojave
    sha256 "4ffd9ecd605d8edf1200fc89f5523c07292b37b5f15fedfea11bba85df863d15" => :high_sierra
    sha256 "35de25f4ae00b335384443a959eeb5b0ec02af0f459f53e425e3a838fed4f3de" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@1.1"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    args = std_cmake_args << "-DRTAGS_NO_BUILD_CLANG=ON"

    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
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

  def plist; <<~EOS
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
    (testpath/"src/foo.c").write <<~EOS
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    EOS
    (testpath/"src/README").write <<~EOS
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
