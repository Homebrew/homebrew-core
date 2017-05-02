class Sshconfigfs < Formula
  desc "FUSE filesystem to dynamically build SSH config"
  homepage "https://github.com/markhellewell/sshconfigfs"
  url "https://github.com/markhellewell/sshconfigfs/archive/0.3.tar.gz"
  sha256 "b52612b2211ca06642cee6a1abef41a53f0361ed16908372329fa464caedb74a"
  head "https://github.com/markhellewell/sshconfigfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e5f5ccfa8356cc53e19bf1a794b0152d6a2083cee84f0777c4e5b9d371e4dfc" => :sierra
    sha256 "f84991229a6701f9483c79232c5e25f3e4577d2e6748c06b5f49808c0ee8354b" => :el_capitan
    sha256 "f84991229a6701f9483c79232c5e25f3e4577d2e6748c06b5f49808c0ee8354b" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :osxfuse

  resource "fusepy" do
    url "https://github.com/terencehonles/fusepy/archive/v2.0.2.tar.gz"
    sha256 "31fe3f8731d33200fea2f97ab64a1b8e68dae0b48c5c1bd9e7485a9905636bc6"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("fusepy").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    bin.install "sshconfigfs.py" => "sshconfigfs"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "sshconfigfs"

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/sshconfigfs</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    # We start `sshconfigfs` in the background and kill it after a
    # single second. This should give us enough time to catch the
    # "INFO starting" message. Actually `sshconfigfs` will die by
    # itself just after printing the starting message because OSXFUSE
    # cannot run inside the test sandbox (`deny
    # forbidden-exec-sugid`).
    (testpath/".ssh/config.d").mkpath
    output = pipe_output("(#{bin}/sshconfigfs & PID=$! && sleep 1 ; kill $PID) 2>&1")
    assert_match "INFO starting", output
  end
end
