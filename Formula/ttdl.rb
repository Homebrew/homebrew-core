class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "03a17397782f944ab8425e2ade224e90d181febc0202b8b80e791df62be7dbca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "022d50d0c99b3194d89aaf0c114c70a36c912bb670b2c71c5748daddbf5c5fc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0de8aa7a86689f2a02642361f3dd5763e67e5a3182ff27270d94c11aa2e02304"
    sha256 cellar: :any_skip_relocation, monterey:       "10997074f5dc0ad423292232fc749a6275eff8071884a196d136f55ab4af1aa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1516f0c4429cf5531c7f104a395ea808b4b6567cfcdd8296050371861b10e7cd"
    sha256 cellar: :any_skip_relocation, catalina:       "690648c6b1a9816179a5f512f31c5ad6f78418fb7ed965c7517bdc7712526c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1db04bdea0eb9a26ca50b0139cff2479678b5eaac12d5991b52457766f89f03"
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
