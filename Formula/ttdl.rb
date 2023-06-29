class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "6cbc92e8e22be01a74d75a44b1d231169ac100fd6960a95ef2b87d468c26736d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e047f6c9eb38174ebd38f88ef5b6a4d1a5a3f3abeeb28fa3d90dd1c3f8571004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407e893f597afc54abf770fcc07853e509b6d2d6e356afecd89c6d1e264b07e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd6af5805aefcfecd8372d0efa5eae8275a11688689455b0e3f4cf78a774c09"
    sha256 cellar: :any_skip_relocation, ventura:        "df33e9e916de2e4f378fcf3a1b83cf5307385091a1c92af37ce56c305b6e9cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "185a93695203b056bad4b454c311f3b6a9693b55dd0761f915a7b2d05721588c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5185c9e88874342df9be78e6803a1936528c3fe7f7f2e99f9592a1973c8ce82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832c2f1b9d36e1646925c161b93b715520f8545c0eaf93b0d31edcc4c9ffcbd3"
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
