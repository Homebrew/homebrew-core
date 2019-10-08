class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/topgit-0.19.12.tar.gz"
  sha256 "104eaf5b33bdc738a63603c4a661aab33fc59a5b8e3bb3bc58af7e4fc2d031da"

  bottle do
    cellar :any_skip_relocation
    sha256 "30c348bcfbdcfc5fe3a91b0bb8889841a5e492f2fed7626577cda1523d815dc2" => :mojave
    sha256 "30c348bcfbdcfc5fe3a91b0bb8889841a5e492f2fed7626577cda1523d815dc2" => :high_sierra
    sha256 "ec7f9140e122265f34c03469803cf7eb932006d240ab158cb9ee5a27f53b3b38" => :sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
