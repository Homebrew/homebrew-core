class Sacad < Formula
  desc "Automatic cover art downloader"
  homepage "https://github.com/desbma/sacad"
  url "https://github.com/desbma/sacad/archive/refs/tags/3.0.4.tar.gz"
  sha256 "31780c419c4ca14310c8ac7023faf03ecb17a0098013f134af9fa750810d322b"
  license "MPL-2.0"
  head "https://github.com/desbma/sacad.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85fe9fefb9abdda3c42ce04cd0b16d559f97503dda0ae934b0f46898970b8341"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3753da68c5c4aaa39b34f97e99e9852da040d5681eb69c0b3496f9b253326454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69e938bb1c21e4d9ee568926027577723621964691a0afb5da92636799443379"
    sha256 cellar: :any,                 arm64_linux:       "790baf7e109be39f3b964ad69ef90ec5deb0042fc5a2b99cc141ea1eeb861536"
    sha256 cellar: :any,                 x86_64_linux:      "a13151c36c1c2facd478bdc6cf145726abb536b2da7b075f108d8c363120725f"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sacad --version")
    system bin/"sacad", "metallica", "master of puppets", "600", "AlbumArt.jpg"
  end
end
