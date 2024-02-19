class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.96.2.tar.gz"
  sha256 "fb3c12e7240449976a8211d161c6e1b743128b12d22964f4b21c233d2dfbec50"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54f0b0638e2cf9f65874f3e752086f1807312852f50f9912b860163727162ff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09ad583aa1a622d1b09359fb0ca52dbba3008a7f1a7020a9936fa3b8ccb16322"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84722344659783a862ba46283ba8c3e626c8dcffcc0e5153f2b0a3394445d63e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e38d4461f462a1919975955ce57df5f4c1c81d1228cb05fd3eb565f13f972cb"
    sha256 cellar: :any_skip_relocation, ventura:        "e05f04567ca076617cfe8c579b2dfeb388ee518b1339c6328df480df2544749b"
    sha256 cellar: :any_skip_relocation, monterey:       "ab730232e8fd8e0369aecd63f78efffa9835f739bea64e36ea5a5d561606e644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c14d3273e7d48c09efb8e58221d6e21b06b65893bfd0fc732f6fb15df363a01"
  end

  depends_on "go" => :build

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
