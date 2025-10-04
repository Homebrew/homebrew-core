class River < Formula
  desc "Reverse proxy application, based on the pingora library from Cloudflare"
  homepage "https://github.com/memorysafety/river"
  url "https://github.com/memorysafety/river/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fe96d3693d60be06d0d1810954835f79139495b890b597f42c2b0bfa2bd8c7a6"
  license "Apache-2.0"
  head "https://github.com/memorysafety/river.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6aa053883945074b92163f95377836cd8dac14606d0406d83bcfef4238f6a2a5"
    sha256 cellar: :any,                 arm64_sequoia:  "07ebac88781c5ead2935d4fcdcf750f10791ac135986c7917e5fcfcf8cad0a97"
    sha256 cellar: :any,                 arm64_sonoma:   "d214bd3778baa4798b1842f4d4a6049d48f02cbe6862418d35e1acc8fe8d319a"
    sha256 cellar: :any,                 arm64_ventura:  "2f254be15ed6c188188fa007bcb48e7124808c8449c95da2bc463b1539852b23"
    sha256 cellar: :any,                 arm64_monterey: "6bb3878f623d205400f5906e4104b7545c1054169766720fc2acb8ddf403a8c1"
    sha256 cellar: :any,                 sonoma:         "32bf41e3c0baccfccc9aa73af1e00178cda928638dab11a67651342a54a9ce67"
    sha256 cellar: :any,                 ventura:        "92a0e801a55f3d122801ce1394b665e4d9ffeff6a6fc3f3aebb14e27ea1335ce"
    sha256 cellar: :any,                 monterey:       "c99da45b6218bbc2254e0f9deefd84aeedb74f44cc7049babfe93e1d9dbbbd35"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "73562d84d8fb211d03d3c07c22145034298bb5bf601b3ff811b07c49569190de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ffd4142bf28d324a32169a8e5cd31640c89af81ae66e3f7f4b2fc548322dec0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "source/river")
  end

  test do
    require "utils/linkage"

    (testpath/"example-config.toml").write <<~TOML
      [system]
        [[basic-proxy]]
        name = "Example Config"
        [basic-proxy.connector]
        proxy_addr = "127.0.0.1:80"
    TOML
    system bin/"river", "--validate-configs", "--config-toml", testpath/"example-config.toml"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"river", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
