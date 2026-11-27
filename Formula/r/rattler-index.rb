class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.9.tar.gz"
  sha256 "a4f491012cf74a71a3c1b659b1e4f601f2a9ac4c197824eafad2ba40f183c54d"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1623d977d4d76f0cd8e882a5d0913596e11b17cde3f4b4949e15bfe01d3cde67"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0293f820c594ccfad0083a0c6ea0e85be06240ba561254bf4fa93d71bc577af3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ed278e678328e9914e972ab3fa78458b3568585338b5c61a86c64dfc8d26e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2048e12ac4a516f1cd709136f72f84c1beda49fd7b1cc1d87ea7bc21016f36e5"
    sha256 cellar: :any,                 arm64_linux:       "f60d7132ad68c0b65b8cbf363d5b433f0c6cb067a7136cd42c56a39a02ad898a"
    sha256 cellar: :any,                 x86_64_linux:      "986bb83528e70c64b16e955d1cd49cbd4ed2204aa7b9df4851fe73b4abe41335"
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
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
