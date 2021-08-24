class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.3.0.tar.gz"
  sha256 "7e7f67f4c3cf7d448847e837df2122069b0cc8f7ed6963431e914b7929655efe"
  license "MIT"
  revision 2
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "1e59825a8fcafd2287531e1c54b7a60e528ac454a4c7a269c3910a13fd7b7249"
    sha256 cellar: :any,                 big_sur:       "3369bd7f8eeb65d058ae02878d1c2f0d20f3754934aba468c4b2646040e6e7dd"
    sha256 cellar: :any,                 catalina:      "41a6db2e28eeae00ff6d1888948d8b7d0f01cd67b3f271341b856cded07ba6ca"
    sha256 cellar: :any,                 mojave:        "7f10022d0c6648741457c2562bc5e521d8dd88dfc4c4d68d1c886739ffd7eb45"
    sha256 cellar: :any,                 high_sierra:   "c932bd8516b6690c45dcbf90ced6ad94d4a0aa5a366de532fe90c4ab82b9a2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "897fbafa2e7d41f8789479b9e3c04c1bff4331b684ecabc3fea999d600ab1190"
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
