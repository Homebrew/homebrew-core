class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/4.2.0.tar.gz"
  sha256 "a8fa90f53611a168ee3052c49f4c4b241481fd35c72fe04fd9d925b102ca91ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdc20cb9f508992bee5fb53bbe862f264e56c98a8f5d6d0de0c0e889fe909527"
    sha256 cellar: :any,                 arm64_sequoia: "1dc74dc83b9ce24f0d76916e4d3d23fd86abf1b5d19fda5775b16dec7f0a6cfc"
    sha256 cellar: :any,                 arm64_sonoma:  "e2bcaa7333fcf926c8b649d0e5398cf00c8c8d7886162a26c38a240ad87dc999"
    sha256 cellar: :any,                 sonoma:        "d38de2b4ed0217d7ebf53abdadbc1c9a61b7ba357ba42ecbd1c78f22f8741f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5266812b24443d965ae2b37d5d682b9b93a59e5be72fa4ed3673fa5d6e4e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1905dad96f7e4df997769d3224025cf6a5f238153d719dc9206535aac4e295"
  end

  head do
    url "https://github.com/libxmq/xmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <root>
      <child>Hello Homebrew!</child>
      </root>
    XML
    output = shell_output("#{bin}/xmq test.xml select //child")
    assert_match "Hello Homebrew!", output
  end
end
