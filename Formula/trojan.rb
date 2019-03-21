class Trojan < Formula
  desc "Unidentifiable mechanism that helps you bypass GFW"
  homepage "https://trojan-gfw.github.io/trojan/"
  url "https://github.com/trojan-gfw/trojan/archive/v#{version}.tar.gz"
  version "1.10.1"
  sha256 "7524fbff42013528dd19b2202cab0ea24085cbdc153d394d086e6bf8294b889e"
  depends_on "cmake" => :build
  depends_on "coreutils" => :test
  depends_on "python" => :test
  depends_on "boost"
  depends_on "openssl@1.1"

  def install
    system "sed", "-i", "", "s/server\\.json/client.json/", "CMakeLists.txt"
    system "sed", "-i", "", "s/\"cert\": \"\"/\"cert\": \"\\/etc\\/ssl\\/cert.pem\"/", "examples/client.json-example"
    system "cmake", ".", *std_cmake_args, "-DENABLE_MYSQL=OFF"
    system "make", "install"
  end

  plist_options :manual => "trojan -c #{HOMEBREW_PREFIX}/etc/trojan/config.json"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/trojan</string>
          <string>-c</string>
          <string>#{etc}/trojan/config.json</string>
        </array>
      </dict>
    </plist>
  EOS
  end

  test do
    system "git", "clone", "--branch=v#{version}", "https://github.com/trojan-gfw/trojan.git"
    system "sh", "-c", "cd trojan/tests/LinuxSmokeTest && sed -i '' 's#openssl#/usr/local/opt/openssl/bin/openssl#g' basic.sh && ./basic.sh #{bin}/trojan"
    system "sh", "-c", "cd trojan/tests/LinuxSmokeTest && sed -i '' 's#openssl#/usr/local/opt/openssl/bin/openssl#g' fake-client.sh && ./fake-client.sh #{bin}/trojan"
  end
end
