class Sadl < Formula
  desc "Downloader for Instagram Reels"
  homepage "https://github.com/CooperDActor-bytes/sadl"
  url "https://github.com/CooperDActor-bytes/sadl/archive/v1.0.1.tar.gz"
  sha256 "e0895e2d4ccbd101eb51b0e401679d67297c1056db6dca16713320d980dd6915"
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--path", "."
  end

  test do
    system "#{bin}/sadl", "--help"
  end
end
