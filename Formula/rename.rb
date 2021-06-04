class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/v1.601.tar.gz"
  sha256 "e8fd67b662b9deddfb6a19853652306f8694d7959dfac15538a9b67339c87af4"
  head "https://github.com/ap/rename.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "308b9f76cf8386eb9c5835204233f0869cc566d9995b383a5215649e8b1c7a48"
    sha256 cellar: :any_skip_relocation, big_sur:       "308b9f76cf8386eb9c5835204233f0869cc566d9995b383a5215649e8b1c7a48"
    sha256 cellar: :any_skip_relocation, catalina:      "2f1c70cacb289e2286bc6ec1e47319d197c2f0d74f8474b303aa2cb9aad8bb0e"
    sha256 cellar: :any_skip_relocation, mojave:        "2f1c70cacb289e2286bc6ec1e47319d197c2f0d74f8474b303aa2cb9aad8bb0e"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  conflicts_with "util-linux", because: "both install `rename` binaries"

  def install
    system "#{Formula["pod2man"].opt_bin}/pod2man", "rename", "rename.1"
    bin.install "rename"
    man1.install "rename.1"
  end

  test do
    touch "foo.doc"
    system "#{bin}/rename -s .doc .txt *.d*"
    refute_predicate testpath/"foo.doc", :exist?
    assert_predicate testpath/"foo.txt", :exist?
  end
end
