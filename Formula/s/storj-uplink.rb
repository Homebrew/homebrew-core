class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.162.3.tar.gz"
  sha256 "5118244d7e5eac8eba8f246a234fd845de30923b6d68d1d521aded869e66d65f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c5139165d06a833fcdeb8ced1354434b0793aeec0b60b63fe67679024a659dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5139165d06a833fcdeb8ced1354434b0793aeec0b60b63fe67679024a659dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5139165d06a833fcdeb8ced1354434b0793aeec0b60b63fe67679024a659dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b430b4a2e7fcc0d6c6189b726a789d300f1ae7722c6e6b16082f1481f2025f7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f53aee320fed8d9f71878274671debfdb1ecbedb7c710c6b768f947bf3cbf7"
    sha256 cellar: :any,                 x86_64_linux:  "b11cbc73b879096b7bbdf49e8f618c8988a3ebaf958ab744cafbeb87c5a848bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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
