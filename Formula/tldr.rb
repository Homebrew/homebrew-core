class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr-pages.github.io"
  url "https://github.com/tldr-pages/tldr-cpp-client/archive/v1.3.0.tar.gz"
  sha256 "6210ece3f5d8f8e55b404e2f6c84be50bfdde9f0d194a271bce751a3ed6141be"
  head "https://github.com/tldr-pages/tldr-cpp-client.git"

  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
