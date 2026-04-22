class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.152.3.tar.gz"
  sha256 "110721222c68cda5307ac1c97e821fa152893c7f9648301a49370540a26509ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b068bc48a7e0a55a12b3629e150c5e70fc792529137626332319f1aac32c2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6b068bc48a7e0a55a12b3629e150c5e70fc792529137626332319f1aac32c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b068bc48a7e0a55a12b3629e150c5e70fc792529137626332319f1aac32c2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c8c7416ac62b1cc95abaaa796b30f0ecffaaa9bc789b7dc8b94fe57d9d0e5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49817d01af2a555c111575b8684ca5a4c3118ca49d7a7587e50f7e6036f70803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daaa3ad9193412a33acc36aabd2e2202337c0d8f0ad942d8bac28902bc1b459e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
