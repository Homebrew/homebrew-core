class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "http://www.finnie.org/software/2ping/"
  url "http://www.finnie.org/software/2ping/2ping-3.2.1.tar.gz"
  sha256 "2e53efd33d0f8b98fcc9c5ece26e87119a6bbbc7c4820a9563610143d46712a6"
  head "https://github.com/rfinnie/2ping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64585890285513e5c21395248cdde5cbeae6bcf24b2ba74cbf8f7d6d2548b81a" => :sierra
    sha256 "9145b21b5192af21907a215bebcebbda617fd4ac7634e4cd1c4b865b7902e1ed" => :el_capitan
    sha256 "fbd70a9e67ed894056f22aff65a2a22cdea219884f1b562dc3cb2a8e83d4fed5" => :yosemite
    sha256 "455058787cef02cf7fb4cd2b1d289764a6863b06caa32868259048947d7fdbd2" => :mavericks
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "2ping --listen", :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/2ping</string>
          <string>--listen</string>
          <string>--quiet</string>
        </array>
        <key>UserName</key>
        <string>nobody</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"2ping", "-c", "5", "test.2ping.net"
  end
end
