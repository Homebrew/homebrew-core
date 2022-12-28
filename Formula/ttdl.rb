class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "1329aef2127fe0bb1d90333946894cb1cb5a8fcd9ab90a8afbd4a0dadb303eab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42d4b170437264848ddfa30c17b27c68c1bdbbc4cdf77b059f112908b8c5a378"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20bcf2ded863f66e49eec481b57168d8959a0347172c412246e371f763a740c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "844467b5a71642b213138ecc750bce75d715cdf0166dd573039f201be01ee7bd"
    sha256 cellar: :any_skip_relocation, ventura:        "07ae6f7a56ad1f3d9b4a51b546ef07e498549af4a6e784e183a0e21a4f71c802"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c86e6c09d9026cc3a6cfec416d899b64fc10e134e5dec7f591d98677cc10cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f09805ba54d777d4075df6f073d3e0a2e7af47f26eb7ce9e74d73b837ca9426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a73b8ff936a1a74088f5834946e5de022e20c0050c65067131360d1ffc8b96"
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
