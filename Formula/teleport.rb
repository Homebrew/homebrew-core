class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.3.0.tar.gz"
  sha256 "0ebda4ebc5482a3e23302df696edf8ad60fb68466e41a4deecc05acf1e76c771"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a4074e2fee67a8cf05357f42ba0dfb878790d5fc547a0fb59ecab94cd82b8d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "82322ab5f3f6d791a96cbb530c8b13417b2bdc3bd233375a946e8ee84c4c28cc"
    sha256 cellar: :any_skip_relocation, catalina:      "1b35b92036bbed489ae1f7ed91bf7d269870cfaf836e2f7e12128ff6ae3d7dce"
    sha256 cellar: :any_skip_relocation, mojave:        "57df152b7d09bad81e755e999f4b830d9f4381572d30cce06ea9aff2256b99a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8375f6bbac4fbe0773fbe6a82758eb080dd752fb4e834990dde00116a3faa914"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/07493a5e78677de448b0e35bd72bf1dc6498b5ea.tar.gz"
    sha256 "2074ee7e50720f20ff1b4da923434c05f6e1664e13694adde9522bf9ab09e0fd"
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
