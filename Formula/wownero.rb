class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.9.2.1",
      revision: "607cb3366876f02616300693132d64a5346f18ab"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "c67f6cfaf35cb5862e83aca0354a80212a474725ee8481cb3c54b28dfac5544a" => :big_sur
    sha256 "8fbb06653656ad4f59af7f1eb7739c0bbd04094b5282a465a13d24c0fe9eec8e" => :arm64_big_sur
    sha256 "000381f47cdf6b098e27c513cb76fb12072e87db8c96bd3f40ce81915f11ca04" => :catalina
    sha256 "8afdc6287f0e31521843a00902ae3449aa140559471a1f5124ab5b74b997066b" => :mojave
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
