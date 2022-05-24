class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.7.3.tar.gz"
  sha256 "0e563f0c01c011ba52dd38602ac3ab0d4378f01edfa83063a00102587410ac38"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f27c015b2ef19765f5b05bdc46294aad6e6a9702bf60379646b2d482fa66cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9901d633289cbcad89857d975830a6e06f05287ab4f63cc23a6f3eb684d3a4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "db10b3c2e7d8601404f5781710a594290db30e21bf7f0c9a2ed39548a8d062af"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6fc0f83d3b83a4c8b278f8344e0f17f3c96146ee61afdb2959ef36029141d57"
    sha256 cellar: :any_skip_relocation, catalina:       "8bbc4dcac66038e6fbaf4c4b21f513e06f7a229268ba9ebbfd636a442bca3d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204d35174833b00da78eb1dc6f0191761d91e23d638a6c4cc660cb7a64835322"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sops", "go.mozilla.org/sops/v3/cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
