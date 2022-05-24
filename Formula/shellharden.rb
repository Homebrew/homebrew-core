class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.2.0.tar.gz"
  sha256 "468406c3698c98deeabbcb0b933acec742dcd6439c24d85c60cd3d6926ffd02c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4df0a98551f3b8a21dd2542c2beb887d11bb0e0ad9c73b6850fc95e2d60bdc0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e8a5bcabd7544e1aae73bb1db2561ad4f88d0bdd12ba240a0a3b2d615aa9dd"
    sha256 cellar: :any_skip_relocation, monterey:       "3a6770751276ff16855df0c311a020755cec588e56045e95c7c49f6a74df055d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b56ce7f1583351611eb9247ea7cde6bbcefaa5370b79c4e4aa34e1c041a91dbb"
    sha256 cellar: :any_skip_relocation, catalina:       "024ba81bf5ca8ac721264f893f0cae56830268dd922d6f015b1ea21d97d91291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe37e5663ef542f05416ed4e2a3abb91716b2252b1e63b52776cc2288b3bceef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"script.sh").write <<~EOS
      dog="poodle"
      echo $dog
    EOS
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
