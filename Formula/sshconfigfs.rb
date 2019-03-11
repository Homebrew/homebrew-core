class Sshconfigfs < Formula
  desc "FUSE filesystem to dynamically build SSH config"
  homepage "https://github.com/markhellewell/sshconfigfs"
  url "https://github.com/markhellewell/sshconfigfs/archive/0.3.tar.gz"
  sha256 "b52612b2211ca06642cee6a1abef41a53f0361ed16908372329fa464caedb74a"
  revision 1
  head "https://github.com/markhellewell/sshconfigfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df2bcba207e8f5b42a13ef9c0cde8d9608cf406de517c38ecc55afe71c8d00f7" => :mojave
    sha256 "5cace9c241c7d1d79df449539edd9ef624efa99a1f00b4e71a052b6e0accd3ef" => :high_sierra
    sha256 "5cace9c241c7d1d79df449539edd9ef624efa99a1f00b4e71a052b6e0accd3ef" => :sierra
  end

  depends_on :osxfuse
  depends_on "python"

  resource "fusepy" do
    url "https://github.com/terencehonles/fusepy/archive/v2.0.2.tar.gz"
    sha256 "31fe3f8731d33200fea2f97ab64a1b8e68dae0b48c5c1bd9e7485a9905636bc6"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("fusepy").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    bin.install "sshconfigfs.py" => "sshconfigfs"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "sshconfigfs"

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
