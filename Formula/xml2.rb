class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage "https://web.archive.org/web/20160730094113/www.ofb.net/~egnor/xml2/"
  url "https://web.archive.org/web/20160427221603/download.ofb.net/gale/xml2-0.5.tar.gz"
  sha256 "e3203a5d3e5d4c634374e229acdbbe03fea41e8ccdef6a594a3ea50a50d29705"
  license "GPL-2.0"

  livecheck do
    skip "Upstream is gone and the formula uses archive.org URLs"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a8bc2144c34a087bd0ec424f1079c0813e3de5e069e1cf23fa5c904125d42be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f1ef27cd811f9b846f80775e4f0981998a7cad1230b0f98261ba42dc85c325"
    sha256 cellar: :any_skip_relocation, monterey:       "52c859eeda679620c5b02db82a7a7d1353c53bd43fae6e53c9028b99afe48b1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6e91ba5879e8891be5aca28eba77249f18c8860d2d387447da0ca13efbe066c"
    sha256 cellar: :any_skip_relocation, catalina:       "832aa209cf47c4f18ad512f7eca2acf76aa047522b3a417466722203203bd71e"
    sha256 cellar: :any_skip_relocation, mojave:         "63b136beee1c47726c6756f3c57bf55fcff4e660cd280d090aa35640138465b6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "548421fe00487faa136c700e4d18f48b6bc349956044e2aa0f65667c3856883d"
    sha256 cellar: :any_skip_relocation, sierra:         "d8d4bb9ceb9d97b648d3fd3cffb1e2fad2e4d82aa6aa3397c22f53fe5468ac56"
    sha256 cellar: :any_skip_relocation, el_capitan:     "85e939873edbb3dd1b072437992a0c404534a5084cccd6f9f76d99b09ddda695"
    sha256 cellar: :any_skip_relocation, yosemite:       "3883d5997021b3a5bd57d8830906cb9b370da0f6e1927b6c7e9dcd6740e05c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51048810fc19ddd5955049fb8d358b0f4862e9333b056efd6d28a0e6c42c6e4e"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "/test", pipe_output("#{bin}/xml2", "<test/>", 0).chomp
  end
end
