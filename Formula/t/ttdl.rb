class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "6f29837ba2cff3090991aca20b01d041bfc8834d02dac243ddea2a12fa9596d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84b732cb4876aff44e71f00aa1265c7fda935e168f3af82bfdb8b8aa0224d477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20486597d3f51ce1add21fd99083a756eb9dc4d3c2ae3776cb4768ae217fe48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83317041ece021d686272de7aedf715b805be6eee9de11c57cb4ac3afc1ae918"
    sha256 cellar: :any_skip_relocation, sonoma:        "302689100db2111e1674d1d8af3ddf3f5ee08615ef4e7069076fe3af93e8177e"
    sha256 cellar: :any_skip_relocation, ventura:       "f4a8a905d15b660f26608647e28f74718ca974d1921818d4aca5ba8c94c3d3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996fc20299d44ea248e8f9aec063ecd69de4b3e5e62fa4259b32fe0e19b92da2"
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
