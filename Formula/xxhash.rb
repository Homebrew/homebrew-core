class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.1.tar.gz"
  sha256 "3bb6b7d6f30c591dd65aaaff1c8b7a5b94d81687998ca9400082c739a690436c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6e4991033c6714cb11fc90c0996431c9aedcd141c7bfc0238c67be3f50515b1a"
    sha256 cellar: :any,                 arm64_big_sur:  "553d5087a9245c5b042acfedf197685439abbf3e2e881c6c89003fbbf60e37fd"
    sha256 cellar: :any,                 monterey:       "cbd0ae700a55045c4682a022e995d95355f7dcbc78fb2b0c4e8b358cc017be06"
    sha256 cellar: :any,                 big_sur:        "d48e3747318130322dad17df3dc6ec849bf289cd0ad13b370ff663f3f69833d7"
    sha256 cellar: :any,                 catalina:       "4cfb42ff9c138e3cca0d1c85ef63714f990f459867b9bf77b1709cd2918f35a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925e35424449086364bee67e756ed7de0997e04d7c291a4ee7a5e778b3555f65"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match(/^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt"))
  end
end
