class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.0.2.tar.gz"
  sha256 "697b36bac910cd44399874499c9fc3cfd734d1a4938e1a777ac2acaa3f5269a7"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64a1b2fff07c11f2054472607283d81ab247c213832e98635d21a4b27c7ca836"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5271c2fbd4d1dd91170baf9024902e6340d21b651c805394e1c95372450b9c2"
    sha256 cellar: :any_skip_relocation, catalina:      "21a2da1eee5e4bee8634bd3fffff12c7919ae87109090dc0446aed6d05a6bbda"
    sha256 cellar: :any_skip_relocation, mojave:        "735441a3af92e3a7de54447c696bb5d808323e1d2b2f0bc4894cd193e5aa474f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f3d7d4ce3d481a8d92a684c64b5c24b091e7e9859f33440d5c8c5f8a1dbf79"
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

    fork do
      exec "#{bin}/teleport start -c #{testpath}/config.yml --debug"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"
    system "nc", "-z", "localhost", "3022"
    system "nc", "-z", "localhost", "3023"
    system "nc", "-z", "localhost", "3025"
  end
end
