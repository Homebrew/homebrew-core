class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "ba0cd9d2433eaff571082ef52bbc26ea74ef3b90760919cb48176dac3936f326"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4a35272a2f6218b98e5c4fba2349cc07073d8c3c47b07ff58784245b5fe7b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8bc33747c30d4639ddd5b0cfb93b49855c873a1b6c5584af10246647217d81b"
    sha256 cellar: :any_skip_relocation, monterey:       "4be8dd2ef4571b058a828e724a8865f4632d0ad076c737a6f27f27571d3d5913"
    sha256 cellar: :any_skip_relocation, big_sur:        "abd9bad232351df682d6f804a942aea6ea60c51efb009917b6eb00ae5a6d35de"
    sha256 cellar: :any_skip_relocation, catalina:       "9c308e55477284ce407498a0f429944ee0137bdaf9d2ee684432247658429f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18eaa70c6be0158071626fc5ac3575ab27fde84d2d9cbd52641fc715d1ea336"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"uplink", "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
