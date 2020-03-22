class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.3.tar.gz"
  sha256 "d729c021ed5bcd29137da520a465632e19cf4c4339e0426546593379a570327e"
  revision 1
  head "https://github.com/rfinnie/2ping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d8ff40ccff243a282ebd2b342f1546a99ea439aed1dae81abc25926fb8185a2" => :catalina
    sha256 "8d8ff40ccff243a282ebd2b342f1546a99ea439aed1dae81abc25926fb8185a2" => :mojave
    sha256 "8d8ff40ccff243a282ebd2b342f1546a99ea439aed1dae81abc25926fb8185a2" => :high_sierra
  end

  depends_on "python@3.8"

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
    system bin/"2ping", "-c", "5", "test.2ping.net"
  end
end
