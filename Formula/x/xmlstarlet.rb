class Xmlstarlet < Formula
  desc "XML command-line utilities"
  homepage "https://xmlstarlet.github.io/"
  url "https://github.com/xmlstarlet/xmlstarlet/releases/download/1.7.0/xmlstarlet-1.7.0.tar.gz"
  sha256 "df4c93458fc6b2ad144d65dccf3ef251349871e0578c5bc59edbfeecf9bf3454"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09631d0ee9ab22a357c16ee928e8d1b972e7b3098e010c7ee17ae53e71ebfe90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "090643f7c2b0378ed14f9b503a3989f5d839da35c2529308416bb3af3cf44ca6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ae76757bf87ab27b3517f6321a7c10db390d6dee14db6b320baff3ba5e398ae"
    sha256 cellar: :any,                 arm64_linux:       "14ff7eea5f94b3b6543040a0a372c5eb42a351e26ab5c0784bffa1617e763eba"
    sha256 cellar: :any,                 x86_64_linux:      "796a03605a7b4cee6d923bc77bd63d4aa3476108aec23c5eff2b8c5ced700944"
  end

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    bin.install_symlink "xml" => "xmlstarlet"
  end

  test do
    system bin/"xmlstarlet", "--version"
  end
end
