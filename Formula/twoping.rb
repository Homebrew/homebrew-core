class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.5.tar.gz"
  sha256 "867009928bf767d36279f90ff8f891855804c0004849f9554ac77fcd7f0fdb7b"
  license "GPL-2.0"
  revision 1
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    cellar :any_skip_relocation
    sha256 "afc820a8d8805247357685e70a6537ff4698ac7ede216c82ced88b2cc33825ef" => :big_sur
    sha256 "a463ffe30d5db0dfddeed3a4bb4cb94d7493a5973d25e5d94d2cb9d7d1713e89" => :arm64_big_sur
    sha256 "7628092d50cccc8ca82ce8cc452e1642a583331bcc80d072fb259c8d121ddbe1" => :catalina
    sha256 "142e2753a32f3b55338238c5cef360c1edb1cbd013a9c36b8c7bb98e2e86a76f" => :mojave
    sha256 "02f9e697dc2cd30675db1006ab304c3c7a4f2e02dbff217fbbbd7d6511ccbe17" => :high_sierra
  end

  depends_on "python@3.9"

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
