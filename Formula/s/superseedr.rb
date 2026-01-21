class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.32.tar.gz"
  sha256 "9f40175ac395d29e7be09bd0a5e9fe23802d39914575c0be816d0fe6c37907cc"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96b9632585778abf7fdd476ef2ebf56a2fcc98ff6140d2e67f0a8bf6341d0e84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3cb9da6de0c72fa251822d1388de035009986273468ec6d9bbbace763cc81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b1e77d62af3a7f255216f70279d65d23de9f9b92e88493369a991348e1e870"
    sha256 cellar: :any_skip_relocation, sonoma:        "47b36b37ecc4eded5db2e3d3f3e490a50546d113c86be45d7eac769139b32e96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46816cb3f844f86fe220c2976dcebf4653e726a6a24acc14c62cf36f8c0bae91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45da8770b6eec0eaea3c91663a5f08ca24b87d02410ec5854daf01907a6aa96"
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
