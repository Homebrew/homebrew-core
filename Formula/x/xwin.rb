class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.5.0.tar.gz"
  sha256 "77179655fa2c3d9d969ff0c365fa0edea32a59ac7098022e4f2753cf3ef0c58e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2ba57a39ad437f4a38a027ec754f16678884b96ca80917096877faa2328844b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b7fdbfdc74fe1602bc142ecb978bc113342d3bccfb373d6d7cdc5f440a77fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef1c3eca011b109804395bfc32699e659e41ffef8b72c483184188d53569c2d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e05674719791477b4c9a913cadcf4af78240458ea4af571b5d2aee08846662a4"
    sha256 cellar: :any_skip_relocation, ventura:        "d88a40a5f192c50f6e60dee05e4b57ac5e7a781cb3c175e53fa4233cb6b6dc19"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c3e33965a10fbe12fbba74ef34bb5e018580b705b6da189a4d401d2cae4125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda616437e9ddc88e03271d94cf9e747f8d5faf6c2d263525e31e043f6325658"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
