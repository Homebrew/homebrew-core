class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      tag:      "v2.38",
      revision: "9687ccdb9e539981e7934e768ea5c84464a61139"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "21c16d5289676a51fdb9736631ed86d12b27d9c0c8034baa310c79f95dd51497"
    sha256 cellar: :any, arm64_big_sur:  "4031ba7d9c52f3834e868c716b04854d45a234312a55a9e31c26bf18c01cce8c"
    sha256 cellar: :any, monterey:       "98d9a9608ab4360ee8aba0269feabada932c622ec2cd1150db8c00c9efe80061"
    sha256 cellar: :any, big_sur:        "b27afadc735d740bcb9ca96d1a9ea5fd77f0c07b663b10b7a09f3c10e696614f"
    sha256 cellar: :any, catalina:       "dcaf7b5babf605732fd9007de2f2196687601f839c4045e9eee26ba4ed641cb7"
    sha256               x86_64_linux:   "580e835fcc2d725ad8abfa7cd62d653ec100f9c9f84801fa4886ba3b84f6c804"
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
