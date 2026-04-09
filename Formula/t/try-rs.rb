class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "86f82d20fe7c309a87a17602425e6669f1ace622f50a545773c9596652af4a2a"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "586d13ee8c3a35464ecfa1e3388aedbd3fb734b629cf94d3f4d115b5539f98fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b199f6e8229b56f8d870f43de6319868bbb84112fbb3c6a81a8a484f998f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9de06b3b5ce8257d8cabb59932d90a3212659e7ebcaec300cc69a37a94759b61"
    sha256 cellar: :any_skip_relocation, sonoma:        "700814241c5d119ee6652aa2f9e662c4f4cf8c44917454ec0899fff2cc711808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f817fd3d78f788da915dbb4dc0e1be312b82403212360db422d857ffbdc9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045c09b2cdf352f14c8c83a698bc247fc427004f1472bbebda08ace52e5d5e17"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
