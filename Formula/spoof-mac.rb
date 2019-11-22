class SpoofMac < Formula
  desc "Spoof your MAC address in macOS"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://files.pythonhosted.org/packages/9c/59/cc52a4c5d97b01fac7ff048353f8dc96f217eadc79022f78455e85144028/SpoofMAC-2.1.1.tar.gz"
  sha256 "48426efe033a148534e1d4dc224c4f1b1d22299c286df963c0b56ade4c7dc297"
  revision 1
  head "https://github.com/feross/SpoofMAC.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f51ae0414f795510d718fa2f754b21bb66f20f5157b2bcf2dafacf78c262c12e" => :catalina
    sha256 "18ea6ecd4ef0b23a9272795ae3991f02f41e964cf76f32d305a4091b3111567c" => :mojave
    sha256 "51eb8c3a59a45e6db0feabfe73c661bd1c082a4d5777cefe3f54767749e01733" => :high_sierra
    sha256 "51eb8c3a59a45e6db0feabfe73c661bd1c082a4d5777cefe3f54767749e01733" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage { system "python3", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<~EOS
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

  plist_options :startup => true, :manual => "spoof-mac"

  def plist; <<~EOS
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
