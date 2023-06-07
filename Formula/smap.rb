class Smap < Formula
  desc "Drop-in replacement for Nmap powered by shodan.io"
  homepage "https://github.com/s0md3v/Smap"
  url "https://github.com/s0md3v/Smap/archive/refs/tags/0.1.12.tar.gz"
  sha256 "870838dc01cbf2a018db8bbdee2ac439e4666e131d1f014843fc5b6994c33049"
  license "AGPL-3.0-or-later"
  head "https://github.com/s0md3v/Smap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd92aa17be58afaa0bc14baaabe80da512f7e636ed061be0bd7fb52600ce6d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57729ea50b7670d200da18b69699d0d2c220d37b70e36a56a63347e226883df9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd6b9fa7d42798c226cea37ded2518da2056cb809964fd3cd202f83f68b70a6"
    sha256 cellar: :any_skip_relocation, ventura:        "6e731e48708f38b78db86630f22e16963b992a26dc2263eb53605cd880692f29"
    sha256 cellar: :any_skip_relocation, monterey:       "86e023078f8974a87f8173e0f6c7698d864f1461b606726c8a04e6d6102cfdc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "78f76525efa1961a7d73524596f9b1d1b6c561dd4878394db3ea256c396e4bf0"
    sha256 cellar: :any_skip_relocation, catalina:       "3105b203330cc0b6f54b8e7b000d82afb253bf6e924cdc6155874aeaa7394896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dce4831163ced243814deed0371518cf969ebb55aedd74bdba4933dd30aef60b"
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
