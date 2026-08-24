class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.6.2.tar.gz"
  sha256 "2d84d005f33444143eb8f68eb72024cd7eb9addd0b933665aaf44de7e071c175"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa412dccc395131028d01afc6e32c01347c7078d23a0ee558cadd7d5224c739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22eec652825897de91472e6bda3e5f290934bf735fa1f70d3644a3613ccf5e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2e5b0568def3a676a62ff9951f0026ff790e04eba02f96691b8b745955e5f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3bc7507689850740c9b970cf317f7904e2d6613d5a8a20ba837a4a9c7c33d0"
    sha256 cellar: :any,                 arm64_linux:   "a3ed8bc0ebc606221409bdf83c331ec87ebc7f7615410e06237ae438fdf4f307"
    sha256 cellar: :any,                 x86_64_linux:  "cb1ff04dee157a498709afdd2e576a2c435edeef81cb86e55a125df78af0947d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
