class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "e5c3fd240b3c84b2baf78bcfab0f39a7fd668c391964f3c69f56906c5e28d2bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa8f870fed0e5c1442cfbf87d47f6046cd3d9f180801e5ecfb4cfa0fcbe182e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a4c7b68ba518565d59ae669e7f326dc1e81e07958237d6ddc42b04732386707"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38d376a72c92c7a722f2bc8ab2ca1ac5fc064e0d59e2b7f266b8b28fd2b5f277"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc2fc8d6260aca0ce0442a744081e996c23ce444fef222f5d2371afdfa9e02c"
    sha256 cellar: :any_skip_relocation, ventura:       "3332efeeaa1a6cf768d96a0db42cc1c4e5dc8448ced198ef5ec7cd1e3d7abccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07837a9f76c05dcff074b7e15ca9d3bd7cff4b78c0d979be149f2266cc45030e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f092a9cbf70b63ea2c0b337a0c8945e2bf95d07c7c53e15660824c7bf7200c9a"
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
