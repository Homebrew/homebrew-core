class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "9384a1a85745ee75a8a09a8b5dbf6ffe9c46dee493d8b4fc0309b0625aff5786"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2832d0bb4d9fb9898c3a511a6ee1971f3a3e9e073c1243964406acc31890b95c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1de6634b8fe6dd59f6f8b16e90a09695573f17cbe5dec43047f81b7ccc6c86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0fb172b12056efa574ab3e6bec79ef51dee5242fbc4e01a023243e923645972"
    sha256 cellar: :any_skip_relocation, ventura:        "d5f79fbf5ad5e932bc4552e6d0093d1b5cba29bdcc389b21310deac7dfb85dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "57e992431482fbb6f3a174dc89e42234612e6054fee1fa3f02d95e920c93f637"
    sha256 cellar: :any_skip_relocation, big_sur:        "98d3f4d040ebc9fa1bbefe781c1759496bd4583bdeea79569328ca9c7504bafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b610649b9e34e236c2a7e8b62cd3d1693e8fdb7f7af85f4a22e381e775c83db3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
