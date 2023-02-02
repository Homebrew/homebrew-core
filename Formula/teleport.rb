class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.3.2.tar.gz"
  sha256 "93801d1b6402b9fa53fd5fa7d4282fdaf8b7ed7956a2b84f9420889003df3b2a"
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
    sha256 cellar: :any,                 arm64_ventura:  "227e63bb572ddb981de58872e254c09bdd75a20b8b263693065a61cb06fb244e"
    sha256 cellar: :any,                 arm64_monterey: "20bfb84d3f55341e7fde3bf4f7d2c7a70886d09c4300028704f16a31a83bd847"
    sha256 cellar: :any,                 arm64_big_sur:  "87e9f2f08d63deac9d224fd5e947ee4a98320374c8397c1d9987259fa10be1f7"
    sha256 cellar: :any,                 ventura:        "1e95c573bcf470578e79f67392172d20913ce69fc6007d5f62e52b1bbe1895d9"
    sha256 cellar: :any,                 monterey:       "90951e643e396796e32c197217ec4db855103b0f49537fab90dc9e12495f562a"
    sha256 cellar: :any,                 big_sur:        "0e5f24df605c686e95b3110268ab419c21617f17a33c9c3ca166c1b0797b22a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78d7f145bee121102c07eec88473cea74bee92a45bcd68acaff5ffb5103af81b"
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
