class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.1.tar.gz"
  sha256 "421aeabd30047a55274f36e5585034f4cfde2fc57d00e23281b6563521fe89f7"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2183fc0e815e0dcd4fe08541ce86861f1b4c307327a1ef5cdab3fc345c052ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7227b01c23e9b707011c58ca03b5ddf7fee7a988ec355968f58a6a6668e8da05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a76a72f23355b8d4232b414c288f7dd67b0324f03a85a75575c0c42841a1e08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cd4a0fa8e3d83e586076153fc7ced8f2e6e9ac98650d6ee795a8a169cce73c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd464f1c1cc52ab2995887d3187ef8508d3d5060cf38d7b0466ef6f5925d1ee5"
    sha256 cellar: :any_skip_relocation, ventura:       "a5c95c87fcbf7e374a0ee3b129e47b814a7195fb8906b17cd6ea74cf4bd07f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5e24c7e42e898bdbe115611bf5947280470f5f2f070050420449ab9e6f14a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bddf27a3436f3f0fde6f3bb929b9fcad049ea6a419e78b133221375f48c00da7"
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
