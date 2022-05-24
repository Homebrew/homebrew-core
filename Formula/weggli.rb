class Weggli < Formula
  desc "Fast and robust semantic search tool for C and C++ codebases"
  homepage "https://github.com/googleprojectzero/weggli"
  url "https://github.com/googleprojectzero/weggli/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "240ccf2914533d7c2114901792240b95a6b632432ddd91d1fe3bbb060e010322"
  license "Apache-2.0"
  head "https://github.com/googleprojectzero/weggli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0944ab09e4cac0f09bfe25748caa10d83d99de52d1379fc30d64d7c22b87a08e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39e53596e47f0ea171008c7f8c12de2f8e14ae134425cfcbbb1d1ae75698b778"
    sha256 cellar: :any_skip_relocation, monterey:       "95c818831ee4ef72ada7b4b316454cb46d4345809a2501ef985472508765888f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2269a1b9996695a50e8c494018a424bb9ceb9cfd060610bd30feb1b7b8fa92a3"
    sha256 cellar: :any_skip_relocation, catalina:       "a9b54765d5adda4ac03351babe93312e959212b7ebf38987f788855cbae73503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a29e869828ffb19877f1c760a308b53b58fa81e6a62aea80f9dbc0b23fc106"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write("void foo() {int bar=10+foo+bar;}")
    system "#{bin}/weggli", "{int $a = _+foo+$a;}", testpath/"test.c"
  end
end
