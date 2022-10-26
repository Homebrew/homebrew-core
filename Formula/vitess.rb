class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v15.0.0.tar.gz"
  sha256 "0951281afc4b583248ca1ce323e882e919bcfd8d12122d6a610722aa67d6fb88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "978406c8fa38a9234d7f7734277d44fb787588c9dcb3d46aef7e8dc02a35abe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7b171ce6976b62e76d9a61ca75ebf28528526da7c6e9fb6760b15225543d8a4"
    sha256 cellar: :any_skip_relocation, monterey:       "6eb65c4772350034e8c5fe04907fbd7e62564d3efa1bad50bb1d08b8a361a6fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d30ddbac7090dec3909d3ba3dfba02b58eb0d98a258c898d5c2c97464f12c54"
    sha256 cellar: :any_skip_relocation, catalina:       "9fc566c5d51a3f4f96cdf03b7c1026870b311733b34de35fea4acc363178da03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352b48b5dcc9bc5dbe4bd2f9eb0d6cb282e42ed059bd248c642790479f5a2890"
  end

  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
  depends_on "etcd"

  def install
    # -buildvcs=false needed for build to succeed on Go 1.18.
    # It can be removed when this is no longer the case.
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}", "VT_EXTRA_BUILD_FLAGS=-buildvcs=false"
    pkgshare.install "examples"
  end

  test do
    ENV["ETCDCTL_API"] = "2"
    etcd_server = "localhost:#{free_port}"
    cell = "testcell"

    fork do
      exec Formula["etcd"].opt_bin/"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}/etcd",
                                           "--listen-client-urls=http://#{etcd_server}",
                                           "--advertise-client-urls=http://#{etcd_server}"
    end
    sleep 3

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/"global"
    end
    sleep 1

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/cell
    end
    sleep 1

    fork do
      exec bin/"vtctl", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "--topo_implementation", "etcd2",
                         "--topo_global_server_address", etcd_server,
                         "--topo_global_root", testpath/"global",
                         "--tablet_types_to_wait", "PRIMARY,REPLICA",
                         "--cell", cell,
                         "--cells_to_watch", cell,
                         "--port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
