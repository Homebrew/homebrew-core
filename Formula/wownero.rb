class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.9.1.0",
      revision: "21fa2b944ba2b4325d0df1c2bf564617818a7b0c"
  license "BSD-3-Clause"
  revision 2

  bottle do
    cellar :any
    sha256 "7dcdd75623cb7bc1c628a36b44a2c1cb6d695fdfa3c0fafdd1e791fca39eb442" => :big_sur
    sha256 "3458461681748020c7906a47cad6c421d82a353f63fe08c3b40da051095b9692" => :catalina
    sha256 "780b99fba1fdd4fa577b46d8c8f0f87b9c6537160b679d7c467ce6e5b99ef55c" => :mojave
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
