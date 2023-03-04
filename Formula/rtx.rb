class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "9a9f5aa1a3117e42833eace102806cc6dcbe3e70fde4a60670890fe794571561"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dda64d1fe3585b586400017be19c766a8e2b6baead2e4f540b5ce2b36d34c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5db8ab6b8314c0a01e2a21627ab405b40a9c0749278a2a736452a9b2f82295b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8c15a9bd5e8df25d3231d3b6ffaf21d40e9ed970eb5e5af8a48814198d676fa"
    sha256 cellar: :any_skip_relocation, ventura:        "b35e616e939c0ce1d10370e99adbc4e1996486bacd512095d66d5108d08203d4"
    sha256 cellar: :any_skip_relocation, monterey:       "ec5b66daab2d202fca280a5db1d34d3681269e4469b774dd01b730b77d5f85db"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1f310a63ff36c30303bbe92110b3e6697385e008a580c740516d5478ba649c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9821525335a925d7a82c3bd1e88c8264b2e7e81e5e7c8b0461c8eebf2bfdd775"
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
