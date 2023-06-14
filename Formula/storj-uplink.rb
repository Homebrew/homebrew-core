class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.79.4.tar.gz"
  sha256 "d2ac7c44b0af223f816c476efdd27eb96850779a4fbb20bdef7010b58e4d6d81"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e581e592685be8e878606931928446b176d0912c21f6356eaddbc5ce4e9b2440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74c61fccc40a6671ea5c54c941a1e2058d9befda56ace5509096afc3c9116a50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec16a18d74f186a7c9290ebb9704da4d40b25472fb7c94fcdb96e3d781b6af7c"
    sha256 cellar: :any_skip_relocation, ventura:        "e42608f41331c19ba05f4b6c447af0287ad95d4ee79a1340fda33acb1b31d63b"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4fd4ef7c83c398a9ec1a640d8f2d9805ccbace81e97bacd662789388a564cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "841ba895da95890e97a8948a7f0ffecd6daa04613aa4cbad63d242d69ec79f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab07236ceb12984dd31a0240b5e32c887d0babafd008b341b23c2ec328f80349"
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
