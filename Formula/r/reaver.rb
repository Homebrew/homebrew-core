class Reaver < Formula
  desc "Implements brute force attack to recover WPA/WPA2 passkeys"
  homepage "https://github.com/t6x/reaver-wps-fork-t6x"
  url "https://github.com/t6x/reaver-wps-fork-t6x/releases/download/v1.6.6/reaver-1.6.6.tar.xz"
  sha256 "e329a0da0b6dd888916046535ff86a6aa144644561937954e560bb1810ab6702"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5905b2c9cb255997aafa2a96c694b88b75dd39eabddcd1801d05971b4331c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e4fe541cec1d31a1e6836829dcf050586e385cd030664c8971f9aac369e2313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa4d8cefff1f3c59bcb4cad2a696bc5e16c1f82d201afe7bc78b22f28f182493"
    sha256 cellar: :any_skip_relocation, ventura:        "be139f6efa3077d3c328684afe33401c2ca6e09e716bf8842d6acc7c71972c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "69e3fcd6c69e7e71bfdbf84a780f466097163cc8a34f8928350d02b4fb57a1ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec036d6b49bce14bfdee5ff3f7f03468148d60b48c06ee75bfd156a9c387baf1"
    sha256 cellar: :any_skip_relocation, catalina:       "e4f10cca5698e3ae3d03841e67d84d277d8e05a06c181567a2a1de5ad74f40a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5301d082e3bd0a833d6b352e994d3b39edced488a46ef597b17aaa1e25669989"
  end

  depends_on "pixiewps"

  uses_from_macos "libpcap"
  uses_from_macos "sqlite"

  def install
    # reported upstream in https://github.com/t6x/reaver-wps-fork-t6x/issues/195
    man1.install "docs/reaver.1"
    prefix.install_metafiles "docs"
    cd "src"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    system "make", "install"
  end
end
