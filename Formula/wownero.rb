class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.0.3",
      revision: "2bdd70d65d266beeca043f207ebb1964463f4a3b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "88742c908e5a13e3135aded896e7b2a4731515df2ba9aacc7ac19dcbb49a768d"
    sha256 cellar: :any,                 big_sur:       "dc9cc5d0ae18a59e612bccaa054bbb5881af3765f805a86605a9e3d89d98f156"
    sha256 cellar: :any,                 catalina:      "31dcef5843c4d23562d2cd4ddd595a179bdb7e9e52ea1975d8439b4cca4a3f8a"
    sha256 cellar: :any,                 mojave:        "9b40812bba76c404a3e28d9f3b6b24e4536ebed63d33dda0065c27a55560df75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c6af124b903d8bbe2538856b3764efafe17707f30f65159ceb8c3cdd4daafa0"
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

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  # Boost 1.76 compatibility
  # https://github.com/loqs/monero/commit/5e902e5e32c672661dfe5677c4a950c4dd409198
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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

__END__
diff --git a/contrib/epee/include/storages/portable_storage.h b/contrib/epee/include/storages/portable_storage.h
index f77e89cb6..066e12878 100644
--- a/contrib/epee/include/storages/portable_storage.h
+++ b/contrib/epee/include/storages/portable_storage.h
@@ -39,6 +39,8 @@
 #include "span.h"
 #include "int-util.h"

+#include <boost/mpl/contains.hpp>
+
 namespace epee
 {
   class byte_slice;
