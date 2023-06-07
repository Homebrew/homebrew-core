class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.78.3.tar.gz"
  sha256 "d2a1f2d41e21ea331f3c82d2491864a205ac4f2d56cfcd43af072da13a8b698c"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f1d39ac67e3eaccdac620a1da62cb80de4953a8c9041ed03100619efa1f0b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9482c97d9a285b2eb55043cb06ec8459bf71c157e391fa765f0c473f4a567fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "868ca229a1aa91d072007af3bbcd0527fc85cffa6506e32d1678acc5ba89e8eb"
    sha256 cellar: :any_skip_relocation, ventura:        "a2324f95529fab65ae4739b40307f41b654429fc82a5860c93422abae7c77496"
    sha256 cellar: :any_skip_relocation, monterey:       "65f86b196e6cccc17d3d19f3fd74432765c528801013717982f76eb7f1d67676"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fd045be12c953294fdbe8fd77c98ada252cd8322595761a2e27eed46ed581f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b47335d06151dd02d449350779abded2b9424acaf208eb7ec0231516546612"
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
