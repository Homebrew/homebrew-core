class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.3.0.tar.gz"
  sha256 "7e7f67f4c3cf7d448847e837df2122069b0cc8f7ed6963431e914b7929655efe"
  license "MIT"
  revision 2
  head "https://github.com/tldr-pages/tldr-c-client.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3369bd7f8eeb65d058ae02878d1c2f0d20f3754934aba468c4b2646040e6e7dd" => :big_sur
    sha256 "1e59825a8fcafd2287531e1c54b7a60e528ac454a4c7a269c3910a13fd7b7249" => :arm64_big_sur
    sha256 "41a6db2e28eeae00ff6d1888948d8b7d0f01cd67b3f271341b856cded07ba6ca" => :catalina
    sha256 "7f10022d0c6648741457c2562bc5e521d8dd88dfc4c4d68d1c886739ffd7eb45" => :mojave
    sha256 "c932bd8516b6690c45dcbf90ced6ad94d4a0aa5a366de532fe90c4ab82b9a2ad" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  uses_from_macos "curl"

  conflicts_with "tealdeer", because: "both install `tldr` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
