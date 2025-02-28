class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.21.0.tar.gz"
  sha256 "ae98caa85a6d66ffdb80dc5176a08e4972816db4841e481cc5372792b8857114"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d063ac3f87ed0c9d8dfb7faa18d0d1f2336dcaf964e892ce6cd665c0c6139c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc6bd14ed75528b3b6ed491573aee9fa05744a5c6767ce317ff21608b24e61c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e45d87db4c03d9954637ef347e756b96b6502b0c8191e1b6ed2bf663bae9410c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90ee26def04e565de272d9c8f3365704db9d3a58f6d9f55d9705b1775a1240c"
    sha256 cellar: :any_skip_relocation, ventura:       "ed78414356db4478d32426951151ddc406de33bcbdc9a930f1b5bcdb30320c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529883d6102dc89256e4f6bfb725277ff89afef6baaed20ec3b3dcd38bd47f6b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
