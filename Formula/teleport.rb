class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.0.0.tar.gz"
  sha256 "86e4fc32a15656f3c4b7a153f4800548998fa2b6867f9fe6d4aa0134472afabe"
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
    sha256 cellar: :any,                 arm64_ventura:  "822c6957899b9c69e052901b6895e35bcfbb07e0bd96f8b0e9b1c66a09df7864"
    sha256 cellar: :any,                 arm64_monterey: "32b994c7e0a317f2353d66dadeea2318df6ab5a91281e496ab9762557435112e"
    sha256 cellar: :any,                 arm64_big_sur:  "88ab515d7f7c545de84f6d1382456b0d3ba27a06cfc0de96cdbbe3020839f5cf"
    sha256 cellar: :any,                 ventura:        "d3b1090ff750782f9b883c6676d7bc598bea5129fb4d73257c6e83d37677acf1"
    sha256 cellar: :any,                 monterey:       "66471b31add48129622fb7f654bd6cb5ec10f0cc556c7b6d3ee4db5b8dfe22ea"
    sha256 cellar: :any,                 big_sur:        "fa7c599523990835f9aa5b2c3e374961897041edb4c39e5937c40ee653377455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c803b6335e69e5f6e3adfdd3c575b1e293f38d3a25e445d225b50142ead83a3"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
