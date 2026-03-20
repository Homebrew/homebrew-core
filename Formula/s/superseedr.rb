class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "48231476c70332f2d474504ad3a1b0263900c63b7706c3cec1ad5352313ccc1a"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b1da020274c8c31b69a24a117a8d8dbeff62a26d09416c2406273f0dfd2932e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548bd8bcb0592c2775b31f8e00af0654023c2ba4da36fcc9de0a3b00af132114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e92da770fb3cbff34cad743919c39ec17b8ebfdd0e9a37f08a40ce0c52dc51f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b988420cae5aa2a4c540f892c1091563888437d09cc549b735f2b4859814be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8880bbb42e920f76eb4f13dc97dd9acc14ed79d87d5e291e05bc87eb57ce474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf49ae081816e936c4d2c9b2e62189a5e23d61ee4db7822539d9369385f9712"
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
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
