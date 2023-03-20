class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.73.4.tar.gz"
  sha256 "e024da452bbea73a55498708e8c0ce3597f0441aedaa1c2215664d6613f9f644"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "924d8e54d6c1ea03fcc5da6ce29ff4f8c8389ec3cb691c56c136903d0d3add5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5933b88516e4c82459df86d3f9fe026f8a7c49f342733a4eae77dfcabaee84fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27a773d522854a0a1e3ce3232dc4d70adb609335c98c4ffa8445ff9fb412c289"
    sha256 cellar: :any_skip_relocation, ventura:        "951f3d229ed2bd6a74a50cb161b793c140a620f46be0987b993677fa5388bcdd"
    sha256 cellar: :any_skip_relocation, monterey:       "45dcbe2bf09b8c841bab6ea1614093a63a17c16b7cd29260312f980ff8c45c8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a84a785795ca6a8c9b5299fa1f2e3521b9eb5bca4d74db383a8d3623773d522b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619dd9dbfc0decb09ce1d0afc684e5e5a92f4aa357480b62f77cd10256a1f83c"
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
