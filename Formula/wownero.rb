class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.0.3",
      revision: "e921c3b8a35bc497ef92c4735e778e918b4c4f99"
  license "BSD-3-Clause"
  revision 1

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
    sha256 cellar: :any,                 arm64_ventura:  "f8f3c23fb5186a037c01c9f4d82742b4d3098d7dd9349949d9f001fab182746d"
    sha256 cellar: :any,                 arm64_monterey: "bbb5a81c9ab36cc09cf1c0cad43110da66a6c0cd9ade96647041172e7285829d"
    sha256 cellar: :any,                 arm64_big_sur:  "6e9eba687f435c197c4c0bd7d2c045091ef80e1eba8c29866e357bd83e7befdd"
    sha256 cellar: :any,                 ventura:        "9dfd70c7f9af50e125581d3f5bda6247b20966c05ec91b587a3e8db3b70c5b55"
    sha256 cellar: :any,                 monterey:       "894e203b6cfe46ae4cd8d3755311da1fe871939152960b997e77a573fd5ad8be"
    sha256 cellar: :any,                 big_sur:        "212b37c687062e20c8e6cf6058b82faf0958b89b322763f30d32fb5ec3c02d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47eedd4c62b8c3c0f0a18f3080a82691d9becab292588658d76fcacd1b2ef65d"
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
