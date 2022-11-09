class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "31a944b1932fb785a191932944ff662a33ad99724cb5bc260acdaf821fb2e088"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9770ff239a2e3ae091e481b62757914ac0eecc694af4d2e9957ae18abd06809a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d2065710f0f98444be64d164d7ca5ad15e37d1fa2ac4e63bdaf46c3d84e08ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7f30a295dfb6c3064a380b6c883df34cd1574df2b2ec5c4227ea934ae391d3d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c2e85d9ed4501e11c0eae1e4c02f4532071c207f5ac15583281c2d27b224fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4148d22b515da0a9da2788f73d90a480a89a64f4c956b8c72a8aad0a946cc4"
    sha256 cellar: :any_skip_relocation, catalina:       "f1f05533082208afce31a2eb6a280050d590ef6332b8aa9fe8bc151a1d2c2808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6a127b0164b7fc35b409a5edd1471397d0058e55a2d7ec7e73981ac5f5c365"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
