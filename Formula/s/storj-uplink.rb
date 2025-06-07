class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.130.6.tar.gz"
  sha256 "4d83339ecc8a705f6e39938666f1ec6a028e974871ddce8196dcd3cd20b850e5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8928c9dbbe295b2135ee7e9118855f30fbba95c3f9e665b003bf9f082d085f5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8928c9dbbe295b2135ee7e9118855f30fbba95c3f9e665b003bf9f082d085f5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8928c9dbbe295b2135ee7e9118855f30fbba95c3f9e665b003bf9f082d085f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c976931d4a9229817ab6cf9978d0b848ef4ae9bfe24828d93d450cc816021ed7"
    sha256 cellar: :any_skip_relocation, ventura:       "c976931d4a9229817ab6cf9978d0b848ef4ae9bfe24828d93d450cc816021ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c44d10296dc43b3cdece29857b65c8c232fe3143aece8db8c9f1866afdbf53"
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
