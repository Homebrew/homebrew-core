class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "b9c33fdd50ee87b344595b0ad4d3be8b5e957d15c8d5dcb27920d6447d6aa6f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e4f062f4b3e4b5b3ed0608c994c4b9cdecb131953d95e5843658c0d7d84e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31935477918fbc6cc07c3d5a895f4e87097a3e3db59b985f3f6b140a9dce55fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "163229b254068baadf2013a7fa954b03e97b3b3cb15ebbe79fe3cf3b25306930"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ccb16653f6631c42524f27fd645bc8209434046452b76d640fea39b85b1f00"
    sha256 cellar: :any_skip_relocation, ventura:       "58eed2a7e8076d83c864ecc11cd88558e3b7340e2ae2f13f862fbceb1553a411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa7301861a3c586b094c1e6942cdaa3a8ca37acc427031c4c508724428fd6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345d41d3234e07bd8b9f13499eeb0b8489354c440e8618acf340ebbc01f657ab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
