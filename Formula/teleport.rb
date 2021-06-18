class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.2.5.tar.gz"
  sha256 "08d8b931cee7e1b0ef676894fcd30ac057f7eda18cee9e73eddb695c3a5d9108"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e286402ce4cb15ecff47ab1730ffd116300574fd70cd9e9855de7028188256e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0feb8ac136d65f2b9087c5770ebae79d7c06b1e9e9b4d06c68cfc837765839d1"
    sha256 cellar: :any_skip_relocation, catalina:      "8032c32a010a0859d798d4dad4fe217e54a4284d6c86fe2688d8111c54390ab5"
    sha256 cellar: :any_skip_relocation, mojave:        "01f722a472b1823e4f21d667b7e308dc937108e4c39167cc0c4e00fbf80d3e0a"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8a30ee4e3570c7db0566028b6b562167aa40f646.tar.gz"
    sha256 "54eedd358523526945d309f16b5c53787bc7a9a9337336661361385a6767fc42"
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
