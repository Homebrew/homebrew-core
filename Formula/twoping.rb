class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.2.tar.gz"
  sha256 "121cebb25c7bbd54ff94097188f5b3580bcf9ecd413ea876a4fef4aecdb35a73"
  head "https://github.com/rfinnie/2ping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd3ba003de2069416c5f3db7a38ed7c373b8d10be89a80bdc2c477f097c63f99" => :mojave
    sha256 "faa232b39f5e7269b84436b9917bdad7f1a34b9de948a46f47c972b6adef7249" => :high_sierra
    sha256 "faa232b39f5e7269b84436b9917bdad7f1a34b9de948a46f47c972b6adef7249" => :sierra
    sha256 "faa232b39f5e7269b84436b9917bdad7f1a34b9de948a46f47c972b6adef7249" => :el_capitan
  end

  depends_on "python"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "2ping --listen", :startup => true

  def plist; <<~EOS
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
