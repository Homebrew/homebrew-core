class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.100.3.tar.gz"
  sha256 "22b371223483b99a44bc06f7f459b450765d21b7d98d81dcc146967b1668bb03"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cd6a8d303cb993fb0b1c5466da20f5814bbee64375642bf8defc3e8ad0d9d49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8173df33a4cfd61d48727ba5d4d41bff5761e143331a80c8529de69e6528e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "893c71a9ac9d81f5bc5b309250e3ae482fa7d8b7d4d15e9627c32015e445acb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "89b99352a752e9ec0df8771b623cf3fac774ecc27c55818997b19905d98e583e"
    sha256 cellar: :any_skip_relocation, ventura:        "5fdf46fb52b2a44d5c245661c0598755d22f76285f9d0f9eb517f2217202dbb3"
    sha256 cellar: :any_skip_relocation, monterey:       "c551c933c65a9b90d4b5d3b1f8369916520a6e080080b2b6d2b62d0820ac2f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac909089e0ce180d946f0297147b2ae047b39554f5b1f4e7cf6686faa46f2d96"
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
