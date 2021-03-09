class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.9.2.2",
      revision: "0e65b21328f88044009838ed963652effe13b5c4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d80890e7ee1eb581b34b03499d02b2448dcedd1f8a1f995328a2c0900d43de9a"
    sha256 cellar: :any, big_sur:       "9c6e61cdf77def4a409b44b0ca5f7a18f05d761f900dd3ceb3b99b4499d6d245"
    sha256 cellar: :any, catalina:      "20768518c25c2477ee4719547d763e50286c7bace569e39ad9fb4f2d1d3df971"
    sha256 cellar: :any, mojave:        "0d5accab8bb0c88ce97f9b215b16c91305474b5d4e6f9fdb73bdf2993a33693e"
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
