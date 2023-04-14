class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.2.3.tar.gz"
  sha256 "54c01056f02656553158a9597b7c4df725f4b33dd6f5239d4ddacba5f24d07d8"
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
    sha256 cellar: :any,                 arm64_ventura:  "8cb54a85a24eef452f63e2f7e62082c2d5b06b80e67a6441ba6f8cd1e22cd11a"
    sha256 cellar: :any,                 arm64_monterey: "f37ec1412fa987342b93e99a3b648df3004be3631ea86440b3908a4f86fb23a1"
    sha256 cellar: :any,                 arm64_big_sur:  "ec9d2176ed25927bc151112a5bfce0bd3894ed64ab48bc94555177ffacd325cd"
    sha256 cellar: :any,                 ventura:        "53d648d7d742e7d422f1e9c0f2b2480f1fd1ce9ffc12628fa9d7b4e59b32e50f"
    sha256 cellar: :any,                 monterey:       "e2ab2aa5c33474d83a4a270dd7e9f8c651f2dbf77453b20e7e092ca0d4423bfb"
    sha256 cellar: :any,                 big_sur:        "5020406a7258c35dc3a3411391a6caceca65b471acc7ceabd8a229a350c60b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbc396f38d814d91faace2dc4a0ccbcc3bbdf03e647676b37d98c2cd76958aa"
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
