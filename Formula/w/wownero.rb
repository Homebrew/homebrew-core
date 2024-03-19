class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.1.0",
      revision: "1b8475003c065b0387f21323dad8a03b131ae7d1"
  license "BSD-3-Clause"
  revision 3

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
    sha256 cellar: :any,                 arm64_sonoma:   "0d5917df785c64870efc131baf0063e727763fb57a9d176adc532c5fa3f1d2a3"
    sha256 cellar: :any,                 arm64_ventura:  "064c62f36d40f0ccd97275ca16df7d60d7a742e1b2011581af090a031bec5872"
    sha256 cellar: :any,                 arm64_monterey: "5569a61438ff6f4c8d33a74ae0278ffe519272a48d783575b4a4e11242ac00cb"
    sha256 cellar: :any,                 sonoma:         "8dc23bc44e581ad063d00c5c706521a03dc72de4de48ae5d3fc8c96a7518eacb"
    sha256 cellar: :any,                 ventura:        "99d9ff616bc5e8cf2e9c5d94f47e0d54a56d90a90f0c5a19a3fa5ab7338ef6b4"
    sha256 cellar: :any,                 monterey:       "8fd5ddd93a8ad92e0679c3e0bd19e127af5db630b9caef2643b416158f81a256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7cd8bb0138e2caccc9ec462049562a51a70febd8e0cdeb8fb2a2f7927a829cb"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    args = %W[-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}]

    # Build a portable binary (don't set -march=native)
    args << "-DARCH=default" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
