class Toktop < Formula
  desc "LLM usage monitor in terminal"
  homepage "https://github.com/htin1/toktop"
  url "https://github.com/htin1/toktop/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "3ce3a9a9737d0d29f10ce1f34a8dfef076ceade49e4ec1202dc7cba955eace66"
  license "MIT"
  head "https://github.com/htin1/toktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30a30bd265db19de073758917740442772cdd6712db3500e5378a218d69b5c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d39463c6f12f08803bf39c5ab6d7e2dd4e8f8fe40033ea9e9ca4f3227f27213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4abd965ad2bfed149e2b478d29ffe90dd4b5cac857bfcd02d31676ceb7533ae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "992187eaddc4f89f27a20b165d312b246db15d4da3b5b64a717ffa587ba7db32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d2da44a7b61babb2e34406fa30abdb5756a4b7e78be143fcde6904d367c90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a402e018dd9765740a1545bf320bc0e07348f2a47cf815c87f1c37e311d2f47"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["OPENAI_ADMIN_KEY"] = "test"
    ENV["ANTHROPIC_ADMIN_KEY"] = "test"
    assert_match "OpenAI", pipe_output("#{bin}/toktop 2>&1", "\e")
  end
end
