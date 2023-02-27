class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "b272e94e7431d82c578d8cdd8115510b748cc46411218d2b07f1cc26e3ec631a"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a554c95f8759b862db0e2f1cda478bb9a0a2d29ed06acfadc54598d35d17b102"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42da2bae829e2372a4caca9ec8072b4fb9a94c09af151976a6658faf6339f6ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e52adbd68aa2baa2ad2ca73e07acf34428bd419e3741bdad06345adc5dea0280"
    sha256 cellar: :any_skip_relocation, ventura:        "f98880457baf9ff6477840057aeff8c3d9a20391590a35ad828e4aab80713215"
    sha256 cellar: :any_skip_relocation, monterey:       "1c9ea3e08db18fd3f9e49cd9f0f57b9b40f966da99f5965f2c88644e60712acc"
    sha256 cellar: :any_skip_relocation, big_sur:        "523aab9050b91a432519620d2569d9e485a0e94220a7bae9c1ce56ba6487ffde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea2cbb603b35ede75033a0fcbdde24a7c35d34dfa750c561a764d7640929b4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
