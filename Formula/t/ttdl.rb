class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "142ce5024177dde5cd1db96a4ada527d8af1249466d2d675f0d7d4b2cde5fcb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6211e6fbd16554221e92a0d57aba28e82201500d9f0bad7b8bb6e827ce00d21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db0feb8c4d4d777f714d46eecfbd6c65c55401b04d099bf33a2d7261a596a990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f36f4b06972412741a8b7b16775ef2ae4e869f54cdd7305b50f258f221425c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbadb7972c1a86c60887de560f7cedea5d324fa697a90a425a0ff3ed096d5a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "75dafa218339b20a328edd759c8575e2c89e53605398299b89445a724c258504"
    sha256 cellar: :any_skip_relocation, monterey:       "d544447debb1395f4e7b23e49fc99e1c506264d42e4fb82d52f237f711421b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dffa23ede0a26a7520e029e37003e20f0fe24ea6a2abf2406de291406fa716c"
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
