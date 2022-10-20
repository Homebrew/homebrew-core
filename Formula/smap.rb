class Smap < Formula
  desc "Drop-in replacement for Nmap powered by shodan.io"
  homepage "https://github.com/s0md3v/Smap"
  url "https://github.com/s0md3v/Smap/archive/refs/tags/0.1.11.tar.gz"
  sha256 "001088c3b530e3551a5014047c26e77953c096b39f0b1f874fb02d557552e07c"
  license "AGPL-3.0-or-later"
  head "https://github.com/s0md3v/Smap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9467e8898e8c7ee7a3f1cb5df4da075a21440b85518bc2141348d32c2f2823d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b1b29dc62ad638bdb45c15617e1dfaea9f73367a6cebae8fe82e159b9ae37e3"
    sha256 cellar: :any_skip_relocation, monterey:       "04455529c5efb9be815ae330a01a8720d9adeacdca06d77a95c10113036ea3a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "67d8d217c5812b1d82b5e739bb7c110bccc38e3b6b9c26a8ce0a880ce49c1e3a"
    sha256 cellar: :any_skip_relocation, catalina:       "cdd62912fdd39f2733e7da053f5ee6cd1525e20c3795154c9fcf3cf81b455e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2087704da39a2a4f9553027e4ab3a408477e01d123b3b06a7d481abf94507457"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/..."
  end

  test do
    assert_match "scan report for google.com", shell_output("#{bin}/smap google.com p80,443")
    system bin/"smap", "google.com", "-oX", "output.xml"
    assert_predicate testpath/"output.xml", :exist?
  end
end
