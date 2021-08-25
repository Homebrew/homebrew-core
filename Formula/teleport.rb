class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.1.0.tar.gz"
  sha256 "0b716eb1cd02b1d41c017954c5a173ab5372ab4698276faab6c45e3f2aedaeae"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5912aa8aa591ce6ec2c44967c8c25a64df8689197a68ac0892eb2b8930a292b"
    sha256 cellar: :any_skip_relocation, big_sur:       "af7f30d71adfbb1fefc8e92858bb63b517fd1fd84ca30f158b7a6365cc723141"
    sha256 cellar: :any_skip_relocation, catalina:      "2dc7f748fe74c9350319de97c9ce1dfc36fd6d5811794f24f857a15820ef4074"
    sha256 cellar: :any_skip_relocation, mojave:        "613bfe055a790dcadfa7d5172203ba93e5330788f1ebe1df701c5fd49a2d0050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c6a81c66efd1aa4f5b3a0d6f6f39035cc4591bc9fbaa7b781b5abe7f059caa7"
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
