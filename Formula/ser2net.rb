class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.1.1.tar.gz"
  sha256 "ad6c8fb34d01be177570323899d840a44c8774399d594595393708162fc61e22"

  bottle do
    cellar :any_skip_relocation
    sha256 "212684df3012508da810e7cd273f1418debf734aacb39949b54aca7b592b1a76" => :catalina
    sha256 "83435a03046d3e3db9461ae4dcf9357f6809290bf91560f2f3d722cac22ee6ce" => :mojave
    sha256 "9be8a962e23275a1400a60f94b5e98fc311cf9c917320b5c03d13edcebe40f67" => :high_sierra
    sha256 "8b4c2e80e4fd884c9761a18684191f5d508c858330989a492922fdb231e1ea5d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :sierra # needs clock_gettime

  resource "gensio" do
    url "https://github.com/cminyard/gensio/archive/v2.0.1.tar.gz"
    sha256 "c66638d28ce4df1e9edf1116b5db49b4ec00fb3c5a11ac0cb3d80c72e7096552"
  end

  def install
    resource("gensio").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # LIBS is set to "-lpthread -lrt" but librt doesn't exist on macOS
    # https://github.com/cminyard/ser2net/issues/3
    system "make", "install", "LIBS=-lpthread"

    etc.install "ser2net.conf"
  end

  def caveats; <<~EOS
    To configure ser2net, edit the example configuration in #{etc}/ser2net.conf
  EOS
  end

  plist_options :manual => "ser2net -p 12345"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/ser2net</string>
            <string>-p</string>
            <string>12345</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
  EOS
  end
  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
