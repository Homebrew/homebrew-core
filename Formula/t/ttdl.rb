class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "62acabdd05de41eaf748fbc86b53bb28be77cf3cb2156a6e2aa2955071738352"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79aafae06d4ea6373a9e961b492900ab4e573b8b5fc6c25a000dc135cef7ce22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89212d3faa5988304962427c41450f6aabe6e1b1546f7d55e5c2b6f129c3634c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86578eae6665f338b5ab8ed46b6d5a39b950469569cec590e243ae50f207518"
    sha256 cellar: :any_skip_relocation, sonoma:        "896c984e901495e355cdb01c5d6d08f57d8b548f24bc78a95f0803a60960473e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f75e8c52393df1fba17cc2b6f72a9606fff6a8e718633e12aaf2b244451fc9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b366020c9f2c78822052a4ae247aea225c02cc5ec5936660a3cca3dcb4e5629"
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
