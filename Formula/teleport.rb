class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.0.5.tar.gz"
  sha256 "70a3985ccae26e575e2903aa74f1a086740c7ff1c7b5cce4a25978451b3ed1ef"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d7f4fa8d8360e73959a0491866733dd6441ef2d21a78fadfa0596eda8150a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d80024e85f0ced66613426ef2885fc1f5145b8cef3ee467db6cbddef4c3121f"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff2b42842eeb92f491a875b197d448fea8f220a7a59fca2fc2bafe34266dff1"
    sha256 cellar: :any_skip_relocation, big_sur:        "87cfa19fd80458499605a37aab6549f0bc4c082f0d40653f6e5930a6aa4f67a6"
    sha256 cellar: :any_skip_relocation, catalina:       "57c88346e3178d763bcf4e16a3db149f453b30081014ccd4fe8ae04565f9bcc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a87f748ec983ac642fbdd4c86108af4368b8495727872b78d27ec2757cd3f38f"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/db4dbe5a7ec2d9bd1540f4fd89d0a6d1a52b8181.tar.gz"
    sha256 "a0a5b30644ade30adb6bf398d34335311326f4d83d42839fa7f47f2238de942f"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
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
