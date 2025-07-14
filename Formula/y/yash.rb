class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://magicant.github.io/yash/"
  url "https://github.com/magicant/yash/releases/download/2.59/yash-2.59.tar.xz"
  sha256 "299a50ea70f23dcbb94cf278f3e99e788b20b613185a0426ed5fdd189b1711ee"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "41f426ba54fdffc5d4268b54bb785b4244af0448459a8c56c429552ff5a0c13c"
    sha256 arm64_sonoma:  "a07798ce2eb7e193860da5aa67f45d00520b102e122e1fcdb5659d013f40b711"
    sha256 arm64_ventura: "341778e242efa6a5966d00e13a4eb09ddbe9a462557d8caf747f4c9fcc786383"
    sha256 sonoma:        "c40888effd879a9b14b1c7348bfebbf980a7899bc143360cfd55654fe9151bea"
    sha256 ventura:       "74c532d36d767b362e6852adaa511a97d535fd61f730e246869248401d73fe3c"
    sha256 arm64_linux:   "767918f66d255a55c2fe13abab8f8ca75924df9c989f5aa2487923be4ed3901a"
    sha256 x86_64_linux:  "c792d79a9395f94d8155878614249008f72798f58496bfff55522dcdcb85c038"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"yash", "-c", "echo hello world"
    assert_match version.to_s, shell_output("#{bin}/yash --version")
  end
end
