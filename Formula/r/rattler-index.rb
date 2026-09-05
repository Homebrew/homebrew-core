class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.5.tar.gz"
  sha256 "d10519a93389710ec66e3ddd4dc90a446233ed184077a1ba4c92e755a844cf99"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d9bddeb232ce11eeb718368aea6ecdadac007edf35bb2063d09e79f261e50c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79cd6621256b794c90c79ad6ab2e34dc61eededa23623117de33cf2755739a7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4488112dd93e99a980a925f9e22911b6d161a358f0a7f8b2827f10cf068ca6e"
    sha256 cellar: :any,                 arm64_linux:   "b2189b95029244fc592a7bd86d0367fce0fb9e2c9fba1e1389dfadbfda571ced"
    sha256 cellar: :any,                 x86_64_linux:  "ef1ea3aece4b612403fa226b877e5d136eda2df92627ffcd7b110a854f5a9613"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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
