class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.2.4.tar.gz"
  sha256 "8fc6d5e9b3c26764852df82ab67874b15167b4a28dbc140224cfa3db2ba8d3e5"
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
    sha256 cellar: :any,                 arm64_ventura:  "3d4a57fb2f536628cc82d9281944bbe268117e6661499270054f7f2775eec502"
    sha256 cellar: :any,                 arm64_monterey: "cf89b516873f9e3b497ae82c8ea85f22927aac786939e7ef9a1f4813298f2da7"
    sha256 cellar: :any,                 arm64_big_sur:  "a49b44eb2928fb225252b8a5d3d475547325c2f6a1c02c0d2344335ddf75eb2f"
    sha256 cellar: :any,                 ventura:        "7efb88f70cb07d6b4555db0ad52af6133fc42b6dbe657483314c361adaea246d"
    sha256 cellar: :any,                 monterey:       "5171e290f185d5b8acee94d18d366bd3ce35631bd39d2425d14ce05470bc624e"
    sha256 cellar: :any,                 big_sur:        "13d22430eadd309504001ad6cbd868db9239009771ad9e3be53ea8d259f4fba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d9b38d6008f72d93a232dd636381f277a5b65b4495f5deee11b3321e0c03fc"
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
