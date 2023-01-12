class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.2.1",
      revision: "301e33520c736f308359fe0e406cc5cfa37ccd4b"
  license "BSD-3-Clause"

  # The `strategy` code below can be removed if/when this software exceeds
  # version 10.0.0. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["10.0.0"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12a3f2c726ace7b16ddeb885f804ac8a934a2ae69f68240cbf97f8881770e7aa"
    sha256 cellar: :any,                 arm64_monterey: "d3452801c8090c6112d5eb21994e0d6eb1c4a5ebc733262e06dceedc13aa6ab9"
    sha256 cellar: :any,                 arm64_big_sur:  "2c487f7a5817ffe170cd97559b0c1adae6590862c65dde6fb44cb11bdf1fef56"
    sha256 cellar: :any,                 ventura:        "bcdd628f31216a2db0ec5aabfa3e38c89c4d774ad7bf75bc5b96ebe1ca6f53cb"
    sha256 cellar: :any,                 monterey:       "0693d162a622c39339617a68353f212883a2ad1be2c5f570158daf562d801e46"
    sha256 cellar: :any,                 big_sur:        "becd1ba1735d7afd07df15d26e4a978ed3ea3138303efa2da9dc84b61ada33f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b085f9e79a6f5a47f2f0ea38af3c5c4a38b4bc9e606978ef6f5654e709d51fc7"
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

  # patch build issue (missing includes)
  # remove when wownero syncs fixes from monero
  patch do
    url "https://github.com/monero-project/monero/commit/96677fffcd436c5c108718b85419c5dbf5da9df2.patch?full_index=1"
    sha256 "e39914d425b974bcd548a3aeefae954ab2f39d832927ffb97a1fbd7ea03316e0"
  end

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix conflict with miniupnpc.
    # This has been reported at https://github.com/monero-project/monero/issues/3862
    (lib/"libminiupnpc.a").unlink
  end

  service do
    run [opt_bin/"wownerod", "--non-interactive"]
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
