class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.2.0",
      revision: "ab42be18f25c7bdfa6171a890ad11ae262bc44d0"
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
    sha256 cellar: :any,                 arm64_ventura:  "22a6f390fd78441fa6db3358c033412b4653edf0c8ade88e6b305024a0baff59"
    sha256 cellar: :any,                 arm64_monterey: "534a027fbcb3a5c58aad7ec30e1a2a96ca54e8af692c3f1329e1ce8c7d66c8ad"
    sha256 cellar: :any,                 arm64_big_sur:  "545e44ab1d59defcf8b8044f1a5584df7cb1f4483f19926d7bfa0a4f95000199"
    sha256 cellar: :any,                 ventura:        "82f4bc6fba08587bbccd071734ddf9c30ce4b16467efe33ca87a8aec3f17c2a2"
    sha256 cellar: :any,                 monterey:       "97ae2ff9de853bed0086a0a5864ae16abf5c349ad428f69faf43bb157395feff"
    sha256 cellar: :any,                 big_sur:        "cd83f5871eca818eeeda63f6a253daa68cc04acd7df77665e849452c636a1c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c83be263f8e9e34be121d9bcab6715affd4cd4946414873219534b453ab7f9"
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
