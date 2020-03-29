class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.3.0.tar.gz"
  sha256 "d384176263c1377b241f4e41f8efd564052e506af00e014240f3874419e187e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a75bdb28063e5c0c4d1882ecabba461eeb719b7f596ab0131011c5334816c7bb" => :catalina
    sha256 "b10ecb37c597fc4ab8cd5078a2389ea2b6f7a8357a46ab459620b8b5a7492d61" => :mojave
    sha256 "cc51ff0b589a0a8a299ee69689a421092bdbe9e47c23ccad2c0d4f27c85a5b0d" => :high_sierra
  end

  depends_on "rust" => :build

  conflicts_with "tldr", :because => "both install `tldr` binaries"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    bash_completion.install "bash_tealdeer"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
