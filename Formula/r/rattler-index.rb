class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.6.tar.gz"
  sha256 "ec4d1d3293f5a7b965f11c08d00ee9235b73ae66c43dca2eb8859eafe421e900"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fef1150d9f20b78ad16c05a61424e45d2685afac9db35070f7497bc29a2f2660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e9ad549f7baac3989a50fb55b9f1bcd07839d9df83d6ea0eb54927b351f34c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba4a19ce604d1bf06085a594e48398746924e5330266115f0b2eb4cf87247b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ab0461ad4acffb2d2764fa82bcba34bb9dde1040fc19fb076bf9e6d9dab763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c1f4698898cef47290ebd2a9782ea2eff5f1680277ae9e367a72f2172fbd728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc70bd3ce9d0caacf72f3b676a38d67175af39fd66f8a7859eff524baf32ab0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
