class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/6.1.0.tar.gz"
  sha256 "84cd94920dee3bf6aa48de4c76c3251b99f6089c0d4737cb53523ab9c8f24821"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d9727ba9cc63580658341ca4639c293e25caea74cbc8ac3367ddcf454a9105c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c88d3136c479f211777c9ef23262612924226dc5a0257cde39008dede8e722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b51783bb5c3b15d4c9d94fd7e65f53b26ae31566e7b2814016f0ba02a19e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "899befc0abf449c2a6f14e82ac6325332f262b70b752b782a48e885d8b9e0af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79c11bbdaf886ad218c3d5e5c6b27f6015838470ac4be3d5268af98ed8e38f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a39e96cce6a04856f4c018085ec9d86694546ecc59970232fee128882933ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/tspin.bash" => "tspin"
    fish_completion.install "completions/tspin.fish"
    zsh_completion.install "completions/tspin.zsh" => "_tspin"
    man1.install "man/tspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tspin --version")

    (testpath/"test.log").write("test\n")
    system bin/"tspin", "test.log"
  end
end
