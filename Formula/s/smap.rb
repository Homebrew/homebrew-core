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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fcac3c34ff7362e78d5674837d531780a9b3b0bd54b54b0172f5dd47ba523f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "76fbb860e3293a917a8c0ea81e911cda57c0af6cb4e8cd89afb5c5063e45676f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "162d821d45208c377855150781facff0c083300805aff8b02303def6c0f107f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd92aa17be58afaa0bc14baaabe80da512f7e636ed061be0bd7fb52600ce6d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57729ea50b7670d200da18b69699d0d2c220d37b70e36a56a63347e226883df9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd6b9fa7d42798c226cea37ded2518da2056cb809964fd3cd202f83f68b70a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "234f22ca3979ed3d55dcce4b355d23e428799b341d851699bae284cb5ab71aa8"
    sha256 cellar: :any_skip_relocation, ventura:        "6e731e48708f38b78db86630f22e16963b992a26dc2263eb53605cd880692f29"
    sha256 cellar: :any_skip_relocation, monterey:       "86e023078f8974a87f8173e0f6c7698d864f1461b606726c8a04e6d6102cfdc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "78f76525efa1961a7d73524596f9b1d1b6c561dd4878394db3ea256c396e4bf0"
    sha256 cellar: :any_skip_relocation, catalina:       "3105b203330cc0b6f54b8e7b000d82afb253bf6e924cdc6155874aeaa7394896"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f5e586b583ee24c689e583cc8cdc55f442f48e80e3a21d0a2fbc5ee09a2a0206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dce4831163ced243814deed0371518cf969ebb55aedd74bdba4933dd30aef60b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/smap"
  end

  test do
    assert_match "scan report for google.com", shell_output("#{bin}/smap google.com p80,443")
    system bin/"smap", "google.com", "-oX", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
