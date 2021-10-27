class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.3.2.tar.gz"
  sha256 "1d4e19f8b46be57b8008ac33b9c2c11efe154b21875a4b28a467ae318286e423"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12a0a23ad3d684368059f0edb05f1a25e7016ffcb3283c2defa4a1a8bb74fd50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "401ddc723703c705e8691ce20a7faee054beb065739ac59d3e2557795e65ec1f"
    sha256 cellar: :any_skip_relocation, monterey:       "4712580c633edaf60bfe5db6ad5fada74aad4779764d360ddf1ca02107d1fcfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ea17881730bbe526227149b8a36b4ea21f3327b663e2a6b45510b01817f2f53"
    sha256 cellar: :any_skip_relocation, catalina:       "1af7d56d61201aea75e23d32d8f003fd582f8b54ce2cf46768deabaa1b7e6d18"
    sha256 cellar: :any_skip_relocation, mojave:         "1196d58d43484f4f80a130e3a2fdc32c1cb7d9bb191819e78d5a7d9faf133e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7745d8d2355c54f9de4f4a2e27202e0907a94c865aa9f7005a187c55b5d52f8"
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
