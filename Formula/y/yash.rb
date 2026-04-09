class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://magicant.github.io/yash/"
  url "https://github.com/magicant/yash/releases/download/2.61/yash-2.61.tar.xz"
  sha256 "a214966f4ff8b293aa5521a4d3ef6e87d707579eee616aa2f8218edaa920d447"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "46f099f162e3f4662a0175e1c63afbf9021bf504863a8fce232234dd1ffe018b"
    sha256 arm64_sequoia: "3aeb8587ce93e7cc6f20ad085aa182c8566e8f200ddf5ffe89a4dade16b8ae66"
    sha256 arm64_sonoma:  "92bd275d4409ac5a5008bebd24b8ad0d33a894951c33109d33bf3d12aa7bd5ee"
    sha256 sonoma:        "285ef911cd740e054a202981e84afe4675fd23ae13bb2a67c0c21b009d38537c"
    sha256 arm64_linux:   "5c532a1a557fcd41f9db0992442d8565c678404f14f3b1903cd45cfa48d4d55a"
    sha256 x86_64_linux:  "7e73a8a59ca2879eee08bcd2e4a3b4262685536ed0197b6cadbc6977aef87ede"
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
