class Teamtype < Formula
  desc "Peer-to-peer, editor-agnostic collaborative editing of local text files"
  homepage "https://teamtype.github.io/teamtype/"
  url "https://github.com/teamtype/teamtype/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "cbf36fd071512e39101aa7de111cbb8b1ae4c0aebf9bd3508eb33e68712bca0f"
  license "AGPL-3.0-or-later"
  head "https://github.com/teamtype/teamtype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fb2d7442ecaaea0c5cf243729e22356ccb76ba979e92c76d5531c8dae77f8ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eadb16bb1a0773f7de641bd279069ee49716abbaed50e9b5241820673bdecfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df7da3909aa55ee7d81883bb41f78944e5a6ee9c1d32d3073f51282734865938"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f050e83510628bdcbf87b0a9befd19f584fb7901a3d5a44b5a1a178ffe57804"
    sha256 cellar: :any,                 arm64_linux:   "c4026250f0f68b91cee85c365a3793f75ac41ff77ac93fec33a43d3b32074cbd"
    sha256 cellar: :any,                 x86_64_linux:  "3e05440ce176a996371de197006bf5a16818eea9011432d7f51fa15a9cb88b6a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/teamtype")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teamtype --version")

    (testpath/".teamtype").mkpath
    expected = "For security reasons, the parent directory of the socket must only be accessible by the current user"
    assert_match expected, pipe_output("#{bin}/teamtype share 2>&1", "y", 1)
  end
end
