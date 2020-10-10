class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
    tag:      "v0.9.0.2",
    revision: "9a58ac48d2f1ebdc94f168e63fdc30604058a7ca"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "8ec66cfd025054b7acd06e119ef569b168900de18e8c7e4cf613149a64c983f7" => :catalina
    sha256 "1270cbab4bf4b1615af99f61b9b74453fecd2c4227755bd43b154d10dc26dbaf" => :mojave
    sha256 "3de1293cafd981fb69f6d4fb2c10e7402ddc09f0015caf19096f544ae3be9a6b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "miniupnpc", because: "wownero ships its own copy of miniupnpc"
  conflicts_with "monero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Fix conflict with miniupnpc.
    # This has been reported at https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
  end

  plist_options manual: "wownerod --non-interactive"

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
          <string>#{opt_bin}/wownerod</string>
          <string>--non-interactive</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    cmd = "yes '' | #{bin}/wownero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 238084 --generate-new-wallet wallet " \
      "--electrum-seed 'maze vixen spiders luggage vibrate western nugget older " \
      "emails oozed frown isolated ledge business vaults budget " \
      "saucepan faxed aloof down emulate younger jump legion saucepan'" \
      "--command address"
    address = "Wo3YLuTzJLTQjSkyNKPQxQYz5JzR6xi2CTS1PPDJD6nQAZ1ZCk1TDEHHx8CRjHNQ9JDmwCDGhvGF3CZXmmX1sM9a1YhmcQPJM"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end
