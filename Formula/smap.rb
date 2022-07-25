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
