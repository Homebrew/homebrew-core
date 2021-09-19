class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.1.2.tar.gz"
  sha256 "c3c45f508261741e6d6e39283802dca38c790962d51d43123f15694a45c946a1"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9aa0a2d759aa93808024f9edcb8b71cfa84837966e9b4a9b6f70a33e29fdf8aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce31d2a5215ecaf2ffde333241270ef6bfc8a62b9b83ca7232dc4d7378f7b9f9"
    sha256 cellar: :any_skip_relocation, catalina:      "11d51547d66014ced421f10386efd0b73f350ea3739c3900a97a4609e0faed1c"
    sha256 cellar: :any_skip_relocation, mojave:        "660170805be890366ae19e4e0ae4254e4921755e7a05ed26c1a6877b501924ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08768776a61cb946ce60c6df03e80fd64b776836f807d4de9868c684d6405e10"
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
