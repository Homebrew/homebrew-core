class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/topgit-0.19.13.tar.gz"
  sha256 "eaab17c64c95e70acfcc9d4061e7cc4143eb5f6dbe7bc23a5091cb45885a682c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cecc5c6c74a94121791b87e8805215ff040072b3c93669d008b5fab7e7f4ec16"
    sha256 cellar: :any_skip_relocation, big_sur:       "010944d089a8f0c8c3f615dc2e0e550cb63adeb4cb337879b43a18eb882f22ec"
    sha256 cellar: :any_skip_relocation, catalina:      "4d9aa5c198e91f80f0fbf137e456239a8c1d65e50e6bd851f9333cf4d32d7127"
    sha256 cellar: :any_skip_relocation, mojave:        "30c348bcfbdcfc5fe3a91b0bb8889841a5e492f2fed7626577cda1523d815dc2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "30c348bcfbdcfc5fe3a91b0bb8889841a5e492f2fed7626577cda1523d815dc2"
    sha256 cellar: :any_skip_relocation, sierra:        "ec7f9140e122265f34c03469803cf7eb932006d240ab158cb9ee5a27f53b3b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f23ef839b0ae19ef10ca2baf5dae69164a93086bfb981d24c643f533bc9b063"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
