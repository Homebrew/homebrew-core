class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.10.tar.gz"
  sha256 "b93f37890e361bb9c332b67aee875a10b2636d2fb8d4e91993cb3b985483c511"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b35bdf2957c02522c14db8d164d64954185de3c313e7bd6b3d91cef3ffd7a7a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175eae99f2220251932da539f84091c8cadebeb5d885944aeca0359d7ac11b58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a6ecd8ab42a4ca684cb4767975b9e8ecd55bdbcc9337c63b33212dcdf9c5af9"
    sha256 cellar: :any_skip_relocation, ventura:        "7057393408c75a312943351f1b56d895a033ee776d8821e030b3d41b12b813f9"
    sha256 cellar: :any_skip_relocation, monterey:       "274b5225ac3cd39b36cd9c45ac0220293f1fda8d33c33ebc13b869d45dfed7b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9964c25bfa87a8a9e5e422d621c99541e69c98090e02ad430b3605f3a4b20a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c1d238eb4761cb2a9ddd8f6d905553b7fadca062b5e233755a6f0063962969"
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
