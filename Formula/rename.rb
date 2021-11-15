class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/v1.601.tar.gz"
  sha256 "e8fd67b662b9deddfb6a19853652306f8694d7959dfac15538a9b67339c87af4"
  head "https://github.com/ap/rename.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7f81a8f319841108fb8082ea6cd5cf591224964e6f34bb0135cf851b7f951f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "308b9f76cf8386eb9c5835204233f0869cc566d9995b383a5215649e8b1c7a48"
    sha256 cellar: :any_skip_relocation, monterey:       "1d7f81a8f319841108fb8082ea6cd5cf591224964e6f34bb0135cf851b7f951f"
    sha256 cellar: :any_skip_relocation, big_sur:        "308b9f76cf8386eb9c5835204233f0869cc566d9995b383a5215649e8b1c7a48"
    sha256 cellar: :any_skip_relocation, catalina:       "2f1c70cacb289e2286bc6ec1e47319d197c2f0d74f8474b303aa2cb9aad8bb0e"
    sha256 cellar: :any_skip_relocation, mojave:         "2f1c70cacb289e2286bc6ec1e47319d197c2f0d74f8474b303aa2cb9aad8bb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a88a0c2cd57632633f5ab3e9078f22903b3c12f0520276c3e408570ff10dee14"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  on_linux do
    conflicts_with "util-linux", because: "both install `rename` binaries"
  end

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
