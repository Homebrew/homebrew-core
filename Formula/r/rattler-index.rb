class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.9.tar.gz"
  sha256 "7155cf68c4663be995b88489a2421cf0e8a314eb7c914bf0cc0beef5f59a89eb"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35901288bb4b2bc8c34fc86c32405ea5108d6984a1b7791171efa60c7fc43aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146cee950f5b29e5f141ed85f82941b2ec588d20ae7cbaa143e85562725771ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d95a67b09018eca2e86567c2c0484d585d2bc8ddd3b3a6b38a103eeb127ea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "81f7537ca0876621fb9216191dcf50b85b1ff2deaf78bc149734b5eba361a668"
    sha256 cellar: :any,                 arm64_linux:   "f6623645b7665aab3fd7d5aaddeafd973851d9a79db2a589166d0ce91c680471"
    sha256 cellar: :any,                 x86_64_linux:  "72513e6f8127cea13aed33f5381153640c3a4646cd59aec971c0ddf4a8cadb36"
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
