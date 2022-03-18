class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.50.4.tar.gz"
  sha256 "8f507ffa4bf70eeeb3cf9dc5c4e7794c9913354495d497bdd1d1cdb2b8453fe5"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7f67cec50db1306d40ee26cea172bfa327a6ff3aeb307fe8d7f947d587a92d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "809a59aa457c64041c650cf030ebc68a44825e138569ff95637dca5c50c3f663"
    sha256 cellar: :any_skip_relocation, monterey:       "586f85efc930b477c1e5e2ec9be988b36459771f04aef44ec353a24bf12b6aa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b48ba1f7faeb181e9a9b1d677333f894f481a2737da16df0423001591ed3c2b0"
    sha256 cellar: :any_skip_relocation, catalina:       "f0790ebf718fa66eb8cebfb89ddb5fbf0bcd877e8c1a77d5cbb9299216b6fb56"
    sha256 cellar: :any_skip_relocation, mojave:         "139cc5540b4fb727a7ef275502b84ecf6682c71ba5549e481cedaa3f1e634a3b"
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
