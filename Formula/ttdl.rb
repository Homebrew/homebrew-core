class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "03a17397782f944ab8425e2ade224e90d181febc0202b8b80e791df62be7dbca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7826db12ebd869f5b168946937a41daeb8afa3951ddc321cd5b86235730c73da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a30dbe59f40897ba15bfe537251af58f6f13d658d3fe5f49696a5f75db8c789a"
    sha256 cellar: :any_skip_relocation, monterey:       "da3fd1ec8218a650aea7541d0bd09ebc33839c3092eb434af83833128f543135"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1c2d4459b40841256beb728ade94af3cbda1c0f6758338606d8a7baccee7943"
    sha256 cellar: :any_skip_relocation, catalina:       "46fa71e184f2cb1bce5ff33bfedb02a405d10e8b38cd86be1a3fc23edafcd521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a88cbfeadc12413d3542a5e18f345bf67add28979cad488aaa5b49044f3b09ff"
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
