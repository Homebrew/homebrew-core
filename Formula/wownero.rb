class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.0.1",
      revision: "a21819cc22587e16af00e2c3d8f70156c11310a0"
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
    sha256 cellar: :any,                 arm64_ventura:  "0dfeac5e973bc9b5de5deb3f42ebd2a6c826d1ad6b600bed5c9d8a790ee5b8cf"
    sha256 cellar: :any,                 arm64_monterey: "9c90f73a4d36d6f9682ce2001711655269ce264a96ad175cf67deca000e3de9b"
    sha256 cellar: :any,                 arm64_big_sur:  "38af1ec31cf413403a13695df787b17873706ace32606fa0abb2f38832077ff9"
    sha256 cellar: :any,                 ventura:        "e1c97f44f000555eef828e21cf2570a771d1b9f0eb944f3d22dea5abcf2d118b"
    sha256 cellar: :any,                 monterey:       "8f34d175710bdc70d8abcbd2380b4d655e965906220afd334219a61fa6a46899"
    sha256 cellar: :any,                 big_sur:        "3ce97f297f01a777bacd460d0ae1637d60832d53e8a6197d26b56be1041f96dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c68bd581bdac4c85b6fda55ea4b31e6c88c00b0be2b3bc2c32bfb66f4493a95e"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  def install
    args = std_cmake_args

    # Need to help CMake find `readline` when not using /usr/local prefix
    args << "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}"

    # Build a portable binary (don't set -march=native)
    args << "-DARCH=default"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
