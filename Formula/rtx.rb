class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "d8c88ca4411b6e0078f3f930b9769291fa4331d10036e70064a7211bdf4b0a3b"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36c1090d47e63c862d62aaaa00c7423c0a889406914822fcee21282905d97bae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c3a270b317793f0fc43ed49f70cb5a2a432a5a1dfb4e6a5d74fd5fbeeebacb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b9f4b9a8db8909da32922e19d8846ce35b9fff66124b909d0f846935c32f50b"
    sha256 cellar: :any_skip_relocation, ventura:        "480a987c0ff465591bd5f9e7b5cec98602423fb7e31d11fe07b94e4a0f775ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "1d14e98994fab9c747a590fc5e83ea59a70f4da788d7cadc287c787140c75102"
    sha256 cellar: :any_skip_relocation, big_sur:        "623c962339044d38dfb3883b6347fd4a747e56973356db2a599291087e283501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84125afc470f9c93e9e28d0375e539e2a63fc112c0624e05313b9f71f2599ba"
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
