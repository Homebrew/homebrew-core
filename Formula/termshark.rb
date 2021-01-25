class Termshark < Formula
  desc "Terminal UI for tshark, inspired by Wireshark"
  homepage "https://termshark.io"
  url "https://github.com/gcla/termshark/archive/v2.2.0.tar.gz"
  sha256 "deefdb0b65e5d5b97c305cf280770724542f8dd122502f616e394c62c91db0c4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c596db102b072f39e1e61c41ac2d09d616f65bc4e3b7a8ca6d0648c8a93f9808" => :big_sur
    sha256 "0422a97e0be00df3518156332b95051687c24b53fbff5946f814fd5c6f96f5da" => :catalina
    sha256 "f0c8ee7fdb686c2bfc788bc661d0e190af1146ebcc0960365369ad764e0ce4d2" => :mojave
  end

  depends_on "go" => :build
  depends_on "socat" => :test
  depends_on "wireshark"

  def install
    # Don't set GOPATH because we want to build using go modules to
    # ensure our dependencies are the ones specified in go.mod.
    mkdir_p buildpath
    ln_sf buildpath, buildpath/"termshark"

    cd "termshark" do
      system "go", "build", "-o", bin/"termshark",
             "cmd/termshark/termshark.go"
    end
  end

  test do
    assert_match "termshark v#{version}",
                 shell_output("#{bin}/termshark -v --pass-thru=false")

    # Build a test pcap programmatically. Termshark will read this
    # from a temp file.
    packet = []
    packet += [0xd4, 0xc3, 0xb2, 0xa1, 0x02, 0x00, 0x04, 0x00]
    packet += [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    packet += [0x00, 0x00, 0x04, 0x00, 0x06, 0x00, 0x00, 0x00]
    packet += [0xf3, 0x2a, 0x39, 0x52, 0x00, 0x00, 0x00, 0x00]
    packet += [0x4d, 0x00, 0x00, 0x00, 0x4d, 0x00, 0x00, 0x00]
    packet += [0x10, 0x40, 0x00, 0x20, 0x35, 0x01, 0x2b, 0x59]
    packet += [0x00, 0x06, 0x29, 0x17, 0x93, 0xf8, 0xaa, 0xaa]
    packet += [0x03, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00]
    packet += [0x00, 0x37, 0xf9, 0x39, 0x00, 0x00, 0x40, 0x11]
    packet += [0xa6, 0xdb, 0xc0, 0xa8, 0x2c, 0x7b, 0xc0, 0xa8]
    packet += [0x2c, 0xd5, 0xf9, 0x39, 0x00, 0x45, 0x00, 0x23]
    packet += [0x8d, 0x73, 0x00, 0x01, 0x43, 0x3a, 0x5c, 0x49]
    packet += [0x42, 0x4d, 0x54, 0x43, 0x50, 0x49, 0x50, 0x5c]
    packet += [0x6c, 0x63, 0x63, 0x6d, 0x2e, 0x31, 0x00, 0x6f]
    packet += [0x63, 0x74, 0x65, 0x74, 0x00, 0xf3, 0x2a, 0x39]
    packet += [0x52, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x00, 0x00]
    packet += [0x00, 0x4d, 0x00, 0x00, 0x00, 0x10, 0x40, 0x00]
    packet += [0x20, 0x35, 0x01, 0x2b, 0x59, 0x00, 0x06, 0x29]
    packet += [0x17, 0x93, 0xf8, 0xaa, 0xaa, 0x03, 0x00, 0x00]
    packet += [0x00, 0x08, 0x00, 0x45, 0x00, 0x00, 0x37, 0xf9]
    packet += [0x39, 0x00, 0x00, 0x40, 0x11, 0xa6, 0xdb, 0xc0]
    packet += [0xa8, 0x2c, 0x7b, 0xc0, 0xa8, 0x2c, 0xd5, 0xf9]
    packet += [0x39, 0x00, 0x45, 0x00, 0x23, 0x8d, 0x73, 0x00]
    packet += [0x01, 0x43, 0x3a, 0x5c, 0x49, 0x42, 0x4d, 0x54]
    packet += [0x43, 0x50, 0x49, 0x50, 0x5c, 0x6c, 0x63, 0x63]
    packet += [0x6d, 0x2e, 0x31, 0x00, 0x6f, 0x63, 0x74, 0x65]
    packet += [0x74, 0x00]

    File.open("#{HOMEBREW_TEMP}/termshark-test.pcap", "w+") do |f|
      f.write(packet.pack("C*"))
    end

    # Rely on exit code of grep - if termshark works correctly, it will
    # detect stdout is not a tty, defer to tshark and display the grepped IP.
    system [
      "#{bin}/termshark -r #{HOMEBREW_TEMP}/termshark-test.pcap",
      " | grep 192.168.44.123",
    ].join

    # Pretend to be a tty and run termshark with the temporary pcap. Queue up
    # 'q' and 'enter' to terminate.  Rely on the exit code of termshark, which
    # should be EXIT_SUCCESS/0. Output is piped to /dev/null to avoid
    # interfering with the outer terminal. The quit command is delayed five
    # seconds to provide ample time for termshark to load the pcap (there is
    # no external mechanism to tell when the load is complete).
    testcmds = [
      "{ sleep 5s ; echo q ; echo ; } | ",
      "socat - EXEC:'sh -c \\\"",
      "stty rows 50 cols 80 && ",
      "TERM=xterm ",
      "#{bin}/termshark -r #{HOMEBREW_TEMP}/termshark-test.pcap",
      "\\\"',pty,setsid,ctty > /dev/null",
    ]
    system testcmds.join

    # "Scrape" the terminal UI for a specific IP address contained in the test
    # pcap. Since the output contains ansi terminal codes, use the -a flag to
    # grep to ensure it's not treated as binary input.
    testcmds[5] = "\\\"',pty,setsid,ctty | grep -a 192.168.44.123 > /dev/null"
    system testcmds.join

    # Clean up.
    File.delete("#{HOMEBREW_TEMP}/termshark-test.pcap")
  end
end
