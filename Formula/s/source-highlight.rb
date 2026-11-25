class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"
  license "GPL-3.0-or-later"
  revision 7
  compatibility_version 1

  livecheck do
    url :stable
    regex(/href=.*?source-highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "fb56b54a67d062c9d5e647a62b2a892aa527b7dbdd6e18d574c6e50bedd936b6"
    sha256 arm64_golden_gate: "0e974eb82d796938a2d79cdf52763c72dc8f9294449cbbc32c818a36c99d7851"
    sha256 arm64_tahoe:       "ce820a91da679e6eed65aebc738efe9e4ed3d60564a1407b9882d2fecf34c305"
    sha256 arm64_sequoia:     "69bef5c333725bee8b5e69535c378d59c47146703164fb888601a0fd8637fc0e"
    sha256 arm64_linux:       "1952a80273bcc8e1456917ade34198a5e7710d43736052517ca22f0f53fa9217"
    sha256 x86_64_linux:      "ecb6f92e503af11624ca259452d09caa7b4b8efc01d59540b245048477668cf6"
  end

  depends_on "boost" => :no_linkage

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    type :unofficial
  end

  deny_network_access!

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # strip boost linkage

    system "./configure", "--with-boost=#{formula_opt_prefix("boost")}", *std_configure_args
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match "GNU Source-highlight #{version}", shell_output("#{bin}/source-highlight -V")
  end
end
