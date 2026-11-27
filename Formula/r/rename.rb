class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/refs/tags/v1.601.tar.gz"
  sha256 "e8fd67b662b9deddfb6a19853652306f8694d7959dfac15538a9b67339c87af4"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/ap/rename.git", branch: "master"

  bottle do
    rebuild 2
    manifest_sha256 "5d1b8bd6b0a6950447d0c07c410e0b76c6e1ee8f43682d3afcf6f6040bb05de3"
    sha256 cellar: :any_skip_relocation, all: "ef28d01adefde7f83ad97aeb21b4af98f66b5594ac7d69bb76f01b3f2ac80145"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  on_linux do
    conflicts_with "util-linux", because: "both install `rename` binaries"
  end

  def install
    system "#{formula_opt_bin("pod2man")}/pod2man", "rename", "rename.1"
    bin.install "rename"
    man1.install "rename.1"
  end

  test do
    touch "foo.doc"
    system bin/"rename -s .doc .txt *.d*"
    refute_path_exists testpath/"foo.doc"
    assert_path_exists testpath/"foo.txt"
  end
end
