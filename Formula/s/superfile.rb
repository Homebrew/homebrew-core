class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.2.0.0.tar.gz"
  sha256 "4f60bd87659708c8b572140487ee4767ea74da502f5546c521793a8c3b30480a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aa0a9a3c2d53f296aeb476022b31fc77e3ca9cc21b5e3b0ec16c13dc9261745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0a668a363a10a75bdb2c22e1e6349e7bf200bdc6dd88ca08e5629410699af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfe9606c1500cbd8d5499f054c57a83591da84519f4045397cdcfc6f09ffa0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab1d4d0b400533724002d810f59dfe2010d778fc9761ae5e6080318291230d44"
    sha256 cellar: :any_skip_relocation, ventura:       "48de83c78a125d956157cda531a37f4f95b879bc435bc24eed592d49f22434af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd92b31687f34f3dcb2ec1aae0d377623eb25501ec8ec720b593d17235ee263"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
