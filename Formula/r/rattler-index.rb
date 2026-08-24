class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.2.tar.gz"
  sha256 "67ffa512775010f81dd9cd72d7c191d2d6f5aa313752eb91dfb689ec62a447b6"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cb07edfefe841162a977f8b6ae4773f7b0cb75bd51fbf4eb4c0dbd94db48907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1326d62630f18959971a251612e8594325a93a29824896e8e92380a44d7cfd8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731d5871325123b36f6396095e6b48809d7297eaf22f6e16ef5b5f4999c913dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb08007429e8e1f915dc69e27e7ecd604524db82d93f1a8dbf23f8ed6521a1a2"
    sha256 cellar: :any,                 arm64_linux:   "459b3d8ad2cafc8041c665ca371d4c0301e28775690d0e6f4a1e811ddd175636"
    sha256 cellar: :any,                 x86_64_linux:  "867fac0c46d86b37a9b94924941ab675ede91b668f3bcf9dcd185b1926bd97e8"
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
