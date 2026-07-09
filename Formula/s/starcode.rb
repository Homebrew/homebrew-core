class Starcode < Formula
  desc "Sequence clustering based on all-pairs search"
  homepage "https://github.com/gui11aume/starcode"
  url "https://github.com/gui11aume/starcode/archive/refs/tags/1.4.tar.gz"
  sha256 "b4f0eae9498f2dcf9c8a7fa2fa88b141c6d5abcf6da44b03d5d85e5f1a8fd5b1"
  license "GPL-3.0-or-later"
  head "https://github.com/gui11aume/starcode.git", branch: "master"

  def install
    system "make"
    bin.install "starcode"
  end

  test do
    (testpath/"seqs.txt").write "AAAAAAAAAA\nAAAAAAAAAT\nGGGGGGGGGG\n"
    output = shell_output("#{bin}/starcode -d1 -i #{testpath}/seqs.txt")
    assert_match "AAAAAAAAAA", output
    assert_match "GGGGGGGGGG", output
  end
end
