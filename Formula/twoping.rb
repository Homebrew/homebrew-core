class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.5.1.tar.gz"
  sha256 "b56beb1b7da1ab23faa6d28462bcab9785021011b3df004d5d3c8a97ed7d70d8"
  license "GPL-2.0-or-later"
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e9926966def35ce6fbd2059bb8539deb15c09edd4abed83e6bb814e087262d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2bd33aa7e38b7c1c8fed34946d7e3938b11b5f90960a882b06fbe41c1767699"
    sha256 cellar: :any_skip_relocation, catalina:      "0978ad67cf29cd0b88b0156c798e7d60e7977de707f0d85810a2bcd982e167cd"
    sha256 cellar: :any_skip_relocation, mojave:        "8edf34efd897e63c2ff25f28775ac0c19e9404535e8c3cd5d233a7f2594a1d71"
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
    bash_completion.install "2ping.bash_completion" => "2ping"
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
