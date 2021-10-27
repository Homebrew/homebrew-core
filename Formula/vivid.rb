class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.7.0.tar.gz"
  sha256 "8eeb0cd692936558756ce0dea8cc132898029005a5c70118be5e3ccf784b4cfd"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab52d6ee4b485875a3b3c999d443c5eca3b045c752ca11cff2bd7b054df376c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db529c13331abf864f50a4e1db4f06cf090d1121bfc26ffae0d4924f77f4cdeb"
    sha256 cellar: :any_skip_relocation, monterey:       "424aa4faa3daaddadc92176cb5a56a58327c362d8d89cb6029896d839df71756"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac9d9ca0cc06b51e932e8e1447659848fb6ddc38f522fc6fa4df9bbc894c868"
    sha256 cellar: :any_skip_relocation, catalina:       "a3e8186f762051a6cf1b3c7dcfbea4a47761653fd282bbfe43fbd563ff168dc9"
    sha256 cellar: :any_skip_relocation, mojave:         "5198e3c4ece298eeb42895d0961d74976890ef422d29dfa8e23ade3ba58ade02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf8009e9771733833317fee2810b482a569265732d22539446ba8d2a67a78bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
