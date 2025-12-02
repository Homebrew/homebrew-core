class Termshark < Formula
  desc "Terminal UI for tshark, inspired by Wireshark"
  homepage "https://termshark.io"
  url "https://github.com/gcla/termshark/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "949c71866fcd2f9ed71a754ea9e3d1bdc23dee85969dcdc78180f1d18ca8b087"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4d25d6397d1fd6a69180bb90da9b2278d6e17b25db52493e8264ca61f5c75403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a0c4f19d16204de97425576057c2ac0d841a78bb26981703c919ed102e104982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "097ad857907c26ef893a9f0863fbe6d21d49d5015068c3bc981f0c7a522ba52f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11cf99e534c667d968ea4daff6c3baf9a86345a6823627ad722398e5c5daeedd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37948c9f61f945ad6044eb03753da35bf735a2ef0599c21ee957c24c6549e670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d95e25d67a299e15d5e9c861c5f1b99b98a58802ba78ec847d1801f6f1ef1432"
    sha256 cellar: :any_skip_relocation, sonoma:         "b32b42612b27155cf760d7411e2644b25ba09fb662b1b8bdd4d0b84821ceb914"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b4d2aa47e0f3796c68add48dfd28b7f79780261d00a62897ab23fa977b8423"
    sha256 cellar: :any_skip_relocation, monterey:       "b22556c8b7777479e5a36c5c8abb9fbcff1e2774feb96383533ece79da6a5a6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b19aa1bd9d176bb52410f2751fd3877e22a8d4ba21ee7cccd93d08ef32c8653"
    sha256 cellar: :any_skip_relocation, catalina:       "ce2586a94ccbc846b9d825e48dfec76e3aec711315564b01db2d87d9643a03b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c4b0b7dd2e10d91bcf7fb4a64b436f5e54ad0e00d7f68d02102a5ab0cbb1be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ee110ad437376b219f4aaa960818850be8e28868c8a0dc3ceff715849c8b1f"
  end

  # https://github.com/gcla/termshark/issues/167
  deprecate! date: "2025-01-03", because: :unmaintained

  depends_on "go" => :build
  depends_on "socat" => :test
  depends_on "wireshark"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/termshark"
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

    File.write("#{HOMEBREW_TEMP}/termshark-test.pcap", packet.pack("C*"))

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
      "{ sleep 5 ; echo q ; echo ; } | ",
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
