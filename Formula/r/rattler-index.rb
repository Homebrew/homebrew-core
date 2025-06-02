class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.23.0.tar.gz"
  sha256 "d6a3e7014a115551e9ba55247446c5b4b3d3edb748766cc225f377075c5543f0"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af8738357043cf63cb9881221bde6434e1454b340bc93f826604eae85a967ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba32bb79abe8bad6cae4ebadeb3046c80ba4d60bcaa6e0e893bc217eff9b3a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18ffea234cc8457421cd50d0791be4c7db2329bbcf84a8eb82c711fa7aefdf34"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92ba6fca239685c242026066c54d4cf91b2b7dbefd251dd264ea3608b8ffd0c"
    sha256 cellar: :any_skip_relocation, ventura:       "f7361777df553d478ba0768108c8de4bf49e0d1dbb659d10cf1ad5ca2872b5fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dec9bc57cba222ed1d86ba806d77f6450c8c32dd2b99f2822933411bafe19bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2811d70dd7f033287b511ed8fb718d582b6ed76c40843ec258d7508440fc21ab"
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
