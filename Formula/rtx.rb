class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f71e46cace11eb21e5835328d31f1d6c765dc8f0015b8112a44e549958885334"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a3523baa779ab0386b37b2803d03c09d516f508ce602709e9c4c7d35ace9a45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb7829c955e85fedd063d43e5b317586204a548e8704417aabf6bd49b83a6d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a09a2aa1a1cc4c50b5b3ec17d75b3ecf20c4f7cdd033de8ca90379075162ef1"
    sha256 cellar: :any_skip_relocation, ventura:        "ff8c38ca804837f7b00e048ed8febae0827b516b3b49c3550d4536316cf37357"
    sha256 cellar: :any_skip_relocation, monterey:       "06cb4d89e51c01a086afeea35701808e9307c02cda7785b30ac0af1cb08f0ac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cd1b26e2078b3c9b0e5b8f48ce783e5507243d92d63e8924d98368a80a8a119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70281e8860e24ea5c43447b0dd4f4e68b2068f8fd5bcd5aa69f315ab3f2bdc3c"
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
