class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.4.tar.gz"
  sha256 "6866969742eef846e627bb1d9b4fecf96cfd0c913dba429b2da24d0184a3a151"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a0f0038ae88425dda88cd712407fd141e6182c08034fe43291b73c268d5a5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13528210accd25aede24260e7511645b5eac4755e5648ca76facc97149beeff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c294ecf857b4807a337d6140e79c8f14a2f74b93bf7b6265534baf8ae24cf9c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "062786428e2904759f841fa99d835960ad73851b843f58de71388fea9d0a2232"
    sha256 cellar: :any_skip_relocation, ventura:       "42151e8cdac2cc87b59bda03063ebec31081bc662e1da90eedc20550c9b03a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c6d635b4030f1c5bb0d14114bdd85065b8a048645e28c5b53f236ec5b6ebf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7614a0d2482f5f22e90d8c1900da771a74b523e2d2738a0dd9e36afcb9e3db3"
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
