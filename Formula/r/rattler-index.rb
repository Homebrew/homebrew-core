class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.7.tar.gz"
  sha256 "3176af159d631fec75838ac03b77f7b9beca7e14603accdbf538cd6d49313b14"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e828caf95dd10b45a2e5c23ebecdf7aa541c3222d81cee1b2aa40b4f87d22485"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2df0eb0c0c489f73e68948aeeedc8827e44e894a822f8aa3858c9ec59c806537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97c03ff45624d9d5bb73db9ae5aaf7638931dcbc3b83bf939009d6d995fb6446"
    sha256 cellar: :any,                 arm64_linux:       "b94537e8bcd4b96600a69a2be844cf52ff0b46be1054fa6e04c6edf51f2b6ac9"
    sha256 cellar: :any,                 x86_64_linux:      "fd8fc4315ab76719cfbe67367683e7ecce3852bb3691be1af71ab2e09905f9e2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
