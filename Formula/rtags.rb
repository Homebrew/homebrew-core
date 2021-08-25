class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      tag:      "v2.38",
      revision: "9687ccdb9e539981e7934e768ea5c84464a61139"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "841f0e639cd56b510b2f2571276c7bcbe3fc86269127222f605c605ec5a074aa"
    sha256 cellar: :any, big_sur:       "78858c44b0a41a2437f5b553069b14a9c612fd77b717e95dbaf1949f8629184a"
    sha256 cellar: :any, catalina:      "a421a220b9d412b03d094fc5ce869813534daf3df87271bc16b0fbf01b3cb305"
    sha256 cellar: :any, mojave:        "84995048fe27191b02332d264e02f7c51178fd5ae5b1f16e6f7be7849adbabcb"
    sha256               x86_64_linux:  "4eafc513cdf548a06aa5756b0c70e5229d21f4d6a777ae9e327e423cc8deb5c4"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args << "-DRTAGS_NO_BUILD_CLANG=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/bin/rdm --verbose --inactivity-timeout=300 --log-file=#{HOMEBREW_PREFIX}/var/log/rtags.log"

  def plist
    <<~EOS
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
