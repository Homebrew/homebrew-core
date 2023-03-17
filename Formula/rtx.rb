class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "a05667165e81df45db016e96b4d4f8c65795423b9b52aa1a7fdd98092c211696"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d78d36d477d365f081e87831b19c03b06747b5bffdec7b84f0072981f66146f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62a642538ec33beb569ac28bca928bb187be90df40a03db798d0940439590af2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21fa15d4df447c0700e614d1b2c6afbbcaea32ef776d1b9cff5741ebd1c2d6c0"
    sha256 cellar: :any_skip_relocation, ventura:        "0f72be7fd3d348f5f640de983fb247d3091509715d9137448309177df52c5dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "f44e54368c6e4322ac3ee1b185c97a0f8e2b28d03f9f516a79db6934393e5bd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4884236266d24fbce61a1aaefdda203cd762ff47efb6048a792b15fbba2118f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be85900a2f7c47e2ed03e2970030a47a457521fbf5fa5ce1d585eba1cb4ce26b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
