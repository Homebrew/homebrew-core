class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.23.3.tar.gz"
  sha256 "266b85bc5fd5abafe5e8cfffc8d5be60175c3b69cee22a58706992ee9ac1a815"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "079f58c86ff5b97ff2657b3ab9ec55ecde07ab9a7fadca79a0946263d2c6cb0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f9d1472111cf60b18374bff4aa68c5a9c7be8d2deaeafee82db533f452cc667"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de95250da6afd4859b12ee9e7bfb2e49787e73b0b83687799824c3e7e536118c"
    sha256 cellar: :any_skip_relocation, sonoma:        "365201c3af57194b383193537b3893265f01ddd69a34ae1dcc7b9f4a75813d6d"
    sha256 cellar: :any_skip_relocation, ventura:       "edf7f02aa6f20aaf09ce93d1053a916d3925f8534fca31fcee66811e9cff9177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c893fe0708fd4f2e5ebab6623f0811ae2470ca37fade288bc1ed95295088da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ff0719014c1e1c22ede4eb2695e70a1d1d219ce835de454b341dd253ec0e8b"
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
