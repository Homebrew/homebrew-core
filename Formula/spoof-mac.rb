class SpoofMac < Formula
  include Language::Python::Virtualenv

  desc "Spoof your MAC address in macOS"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://files.pythonhosted.org/packages/9c/59/cc52a4c5d97b01fac7ff048353f8dc96f217eadc79022f78455e85144028/SpoofMAC-2.1.1.tar.gz"
  sha256 "48426efe033a148534e1d4dc224c4f1b1d22299c286df963c0b56ade4c7dc297"
  license "MIT"
  revision 3
  head "https://github.com/feross/SpoofMAC.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c5ff7d0dcbee39117fd4283df8004801cee32ef8b411d2f59e552c8d467dcf61" => :big_sur
    sha256 "25919d55ba6ef291b597523bdd49fdd0b7187a8efb74ef9380868538d8430555" => :arm64_big_sur
    sha256 "474cd1f2612f09b7f21b3599398229d298ceb0591d98aec71bfc87739ea2dfa1" => :catalina
    sha256 "eca350845f847153d91c854f36ff772e1f685cb47c67491d215b9c9e0dbc3364" => :mojave
    sha256 "836ef07953fdc3689dc4367c466666396e9810a1afd844b1a27cd59e0e631ea1" => :high_sierra
  end

  depends_on "python@3.9"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Although spoof-mac can run without root, you must be root to change the MAC.

      The launchdaemon is set to randomize en0.
      You can find the interfaces available by running:
          "spoof-mac list"

      If you wish to change interface randomized at startup change the plist line:
          <string>en0</string>
      to e.g.:
          <string>en1</string>
    EOS
  end

  plist_options startup: true, manual: "spoof-mac"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/spoof-mac</string>
            <string>randomize</string>
            <string>en0</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/spoof-mac", "list", "--wifi"
  end
end
