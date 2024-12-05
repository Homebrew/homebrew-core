class Sadl < Formula
  desc "saltyaust downloader in rust"
  homepage "https://sadl.saltyaus.space/"
  url "https://github.com/CooperDActor-bytes/sadl/archive/v1.0.1.tar.gz"
  sha256 "e0895e2d4ccbd101eb51b0e401679d67297c1056db6dca16713320d980dd6915"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/sadl"
    man1.install "man/sadl.1"
  end

  test do
    system "#{bin}/sadl", "--version"
  end
end
