class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.5.tar.gz"
  sha256 "867009928bf767d36279f90ff8f891855804c0004849f9554ac77fcd7f0fdb7b"
  license "GPL-2.0"
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e76c2949b024e9d3bb26d2f2861b859a51d3f8b0508f5ba8f76d1b2e1d63f3e" => :catalina
    sha256 "2e76c2949b024e9d3bb26d2f2861b859a51d3f8b0508f5ba8f76d1b2e1d63f3e" => :mojave
    sha256 "2e76c2949b024e9d3bb26d2f2861b859a51d3f8b0508f5ba8f76d1b2e1d63f3e" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  plist_options manual: "2ping --listen", startup: true

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
    assert_match "OK 2PING", shell_output(
      "#{bin}/2ping --count=10 --interval=0.2 --port=-1 --interface-address=127.0.0.1 "\
      "--listen --nagios=1000,5%,1000,5% 127.0.0.1",
    )
  end
end
