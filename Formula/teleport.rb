class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.1.1.tar.gz"
  sha256 "385aa94568019b05e3e8249e91aac1e2c196a000de91508312ce166633501379"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9627a4a448bb0b735fd53ba940d6d3e7e94e73455c90ff2825a4048f2adaa75"
    sha256 cellar: :any,                 arm64_monterey: "7f1678b48c16935d06d27ac1641e7d276439bd3d27bc3dd4ec06b396b360d59e"
    sha256 cellar: :any,                 arm64_big_sur:  "745a9dbdbfab1e77ba450a43a8b4b335fcc1edf5977c395256a3a386e8cb144f"
    sha256 cellar: :any,                 ventura:        "8d661d0321ac2b0247c886912a8e0f8c663b79eac6a36dab70dd24067d0afb9e"
    sha256 cellar: :any,                 monterey:       "26a396b4eb04037576922926f8ccec87b73c1619912d755ae31bf74a01dc801b"
    sha256 cellar: :any,                 big_sur:        "504c34af7e60d74c34bbbf1d3030c48740beb4d93ccb8f249464583b00fed246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25512ee729cc81abbf08435d1036aac6cc76c300218cdef91c5372db49eaf23e"
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
