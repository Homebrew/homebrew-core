class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.18.tar.gz"
  sha256 "b22d33c68a64976583d81b7acc06925c7f1307a1a93ab24e372a4221266cf663"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d5ea8861bb2d2c5a6b941be8af3fa31b9ddebca3d407c88448094420c34879f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed4b322faebbad751611f4fba9b44d6b55a57fa9d6b4424ed7299fa3b00f649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1f5ac8685c58321a049680df5e905c1ca6a51bd8a96c515f74faf168b7e271"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffbf1cdcae87353a70d650ede0461fd6f57b5468531670b527cff3b0ead4541a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b45b86783b2375e9c6467ce50f8449f8c26df1c9a4f20f5dd788b3315f6b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a158316be8a77596d82f814473c58cc55de3d8f3a18c73d3cf069c3b8de06060"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
