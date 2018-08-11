class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.1.2.tar.gz"
  sha256 "961c1b67b2d63599e439ff00facc0270e60b67809b26e6fcc048dcbed2d5966d"
  head "https://github.com/rfinnie/2ping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c26393a8739488bdce5ec1353343df5adad1f6ef0be90552ad1679e00db8e10" => :high_sierra
    sha256 "9c26393a8739488bdce5ec1353343df5adad1f6ef0be90552ad1679e00db8e10" => :sierra
    sha256 "9c26393a8739488bdce5ec1353343df5adad1f6ef0be90552ad1679e00db8e10" => :el_capitan
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
