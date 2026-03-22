class Tuckr < Formula
  desc "Super powered replacement for GNU Stow"
  homepage "https://raphgl.github.io/Tuckr/"
  url "https://github.com/RaphGL/Tuckr/archive/refs/tags/0.13.0.tar.gz"
  sha256 "8878bbe5017e9c34227598eda489f6e0b18e364d7ac75cc4488efbae91b630c8"
  license "GPL-3.0-or-later"
  head "https://github.com/RaphGL/Tuckr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4746e35bff4ec91205d140fbc1edc2575a67ffed4eeece5c765ee33082b40c6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cfff7e61489a5bde54ede3aebea68a4ca39369193da958e4669655e992073ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c2f920bfbf4838b8fe6c936ec93d8a4303a29c71527ffe6bc9b02561111e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "edffb701526d884abaf732ce5f603cad0718c929d50bb23828ac394c4dbcf186"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21b0a789446ea055fdff5b00f3c42e05c3141be27627992c379907761d5a3bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d3e69c2946bb0013779c9393e645cb3802dd24ef659a32c56f1b274549d4228"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/tuckr status 2>&1", 2)
    assert_match "Couldn't find dotfiles directory", output
    assert_match "run `tuckr init`.", output
    assert_match version.to_s, shell_output("#{bin}/tuckr --version")
  end
end
