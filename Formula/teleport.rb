class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.0.0.tar.gz"
  sha256 "cee16006019273c3826d4bd9ca425f50a18135846a8dd61af5b46207ae5b7afe"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f7bf92bb44028e0d0a8c8f2b0a4ce1e4bb56f3e7aca6a6114d11274ece3d7b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1fcbd49b535b37e1f0d10afd77b2dbc95b43616c7c4694d61dc12c5f16affb99"
    sha256 cellar: :any_skip_relocation, catalina:      "24f1d5ebbe600a406cb227f153c6033707f19116ccdc0ab696f8d4da38a7f737"
    sha256 cellar: :any_skip_relocation, mojave:        "0fc72099413f9a0ce52643a97ee2241ea003e4ee98fec56d0fbbbe089fa1e017"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/2891baa0de7283f61c08ff2fa4494e53f9d4afc1.tar.gz"
    sha256 "7ce9278f35531f85d070e2e307c6e04d68ea4bbf757726a4776e284a68798776"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
