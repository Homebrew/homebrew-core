class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "625f8f0c8ed97abaa452ac69c2c9cfd6b83dfed00e8f318644193027ab8099be"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac1f880a11b0640c31f82ca187563796728e909045992b30f63b18f9256fc61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a5fdba731a3b1b742193106d82353c762adbe96e9e81e52c2ef72a2b7b2ebe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f763cdd5787e31c50dff2ae1999e15d01aacd54fcc0afcdabec446d9669018b"
    sha256 cellar: :any_skip_relocation, sonoma:        "31e15e2713c9f9d422aeaba0f51bb2e0cdf68dd8642890b520f169266b713024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140eca0cd3ccb0b28c4c439242f930f2163fbb12315826ee18e594eca88bca2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "878878f2a79856f159029d4165d70e75ef57eed9c3d84ec9a632ebc48646e26f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
