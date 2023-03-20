class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11",
      revision: "6b28de1cdc020493dee2bf20b62c6d9227140ef2"
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
    sha256 cellar: :any,                 arm64_ventura:  "e51edda9a4e99b86db62f75f34a13a63298d67eba666d5236b00d3d9a8e34a00"
    sha256 cellar: :any,                 arm64_monterey: "99020211fdfc9418d549db6d01e04cea5d7c81c14ab91908acc3c27b9aefcb97"
    sha256 cellar: :any,                 arm64_big_sur:  "7a87c7cccf3f20b832b9adbc2dc1c6954f799b5ddb21b6810c0b8b191cf4c8a8"
    sha256 cellar: :any,                 ventura:        "cfbe64894310128c156a8c6238bcd5bf7672e510648fd3ce03132402cde34332"
    sha256 cellar: :any,                 monterey:       "8870663fb1727385e2c3f44732a5f165e91bb986694510c017f22d6046ce7055"
    sha256 cellar: :any,                 big_sur:        "0333fc125862694ef21877f86a719526b90b1e41ca1175f19d4a86af5644f338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5fa75bd9971927f759140c85657a2f4c0ca26d27ea8e3678d545bb5191a351"
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
