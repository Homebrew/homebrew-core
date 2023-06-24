class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.80.10.tar.gz"
  sha256 "5ffbb768f5e4cf35d2e3ff0668ad22f4139f2d42ab48df525aebe9d9c6e6f20a"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0ce5ef25740c7257b7283b51e004d96d7c68108c457c11a0866e8957c5340a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22cae650885609e4421fd567a43594ddcd2a80d5bd0850d8ca43eb2277eb353"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99a188bcc1506d68172c9f6073607d6e169f7b6dad54744e1a3dbf0c6a3d21de"
    sha256 cellar: :any_skip_relocation, ventura:        "a1509758d1a383af1e97502b5c15eec07b3da260f3df7ab3f8f47e0bc81ba339"
    sha256 cellar: :any_skip_relocation, monterey:       "3e767fbea03ba42ae1b43b744a37647b153c076be1853d5839592fcf91e5ba67"
    sha256 cellar: :any_skip_relocation, big_sur:        "12ad62347e60ea0dddb1f8477920c8ee3bea688bee6d24b738d4829b123b5c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d46e6c2ab427342314c2393a5a8024d13bd752954cb08c234ad2f3380899cdb1"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/storj/storj/commit/873a2025307ef85a1ff2f6bab37513ce3a0e0b4c
  # Remove on next release.
  depends_on "go@1.19" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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
