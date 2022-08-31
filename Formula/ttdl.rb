class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "c20608c20233aa4495eabed631e70448e307e8ab0b006f328d6e72d3278311b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e39184accfa7e011c9e1789422c66ceef1b5b7c26890babedca76db0c8ca85ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30e4512b63398c41afe5f352260d08cef1d32ddcf21effd29a2632afe4cfa1bf"
    sha256 cellar: :any_skip_relocation, monterey:       "c8bf930a2293a39b604109879882f4ff9d06152bbe4d5e01dbedd72c3c1a1553"
    sha256 cellar: :any_skip_relocation, big_sur:        "82fe56f5bf9731ef770184a2b75a12531ec47bde23b5949de7a871ee3a8ef085"
    sha256 cellar: :any_skip_relocation, catalina:       "f36cc2d52cf4a82bfbef869a6fdbe01a3a1478ca10a9ece3d391f6c3d6653c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a60d913a01c7d163d4157a16117b3e818194fec47c051b4f6935b7dd2a8611"
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
