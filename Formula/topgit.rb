class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/topgit-0.19.12.tar.gz"
  sha256 "104eaf5b33bdc738a63603c4a661aab33fc59a5b8e3bb3bc58af7e4fc2d031da"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "010944d089a8f0c8c3f615dc2e0e550cb63adeb4cb337879b43a18eb882f22ec" => :big_sur
    sha256 "cecc5c6c74a94121791b87e8805215ff040072b3c93669d008b5fab7e7f4ec16" => :arm64_big_sur
    sha256 "4d9aa5c198e91f80f0fbf137e456239a8c1d65e50e6bd851f9333cf4d32d7127" => :catalina
    sha256 "30c348bcfbdcfc5fe3a91b0bb8889841a5e492f2fed7626577cda1523d815dc2" => :mojave
    sha256 "30c348bcfbdcfc5fe3a91b0bb8889841a5e492f2fed7626577cda1523d815dc2" => :high_sierra
    sha256 "ec7f9140e122265f34c03469803cf7eb932006d240ab158cb9ee5a27f53b3b38" => :sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
