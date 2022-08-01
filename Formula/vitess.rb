class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v14.0.1.tar.gz"
  sha256 "ea4a0fa15c294489a2d0d84a1f09fc2ccf8909a8b83e7f8e4988b9b28c0244b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e551f0848cc94229ed8c6de897c41abe77be0cf6223bbaab0168265a224238"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8be9fa730390cd0b0eae609b38c8cb5cb514d9082beb0cdd00e7ec9d4a90706f"
    sha256 cellar: :any_skip_relocation, monterey:       "1d4182ead3e32bc826fd26957a53a45528fa19340844e67bdebb2bb328025016"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9ea294791e6c8f997ded8aed3291271d437f64c23d2c49066addb09760364fa"
    sha256 cellar: :any_skip_relocation, catalina:       "560aa762df3042d7e9134945847b7a8a457ed9ebe62b1671760c02aa39181bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54cc14edcbf055ecede0cb9743143ceaf6b89fa0e005cfa415e43d0ff4441d11"
  end

  depends_on "go" => :build
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
      exec bin/"vtctl", "-topo_implementation", "etcd2",
                        "-topo_global_server_address", etcd_server,
                        "-topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "-topo_implementation", "etcd2",
                         "-topo_global_server_address", etcd_server,
                         "-topo_global_root", testpath/"global",
                         "-tablet_types_to_wait", "PRIMARY,REPLICA",
                         "-cell", cell,
                         "-cells_to_watch", cell,
                         "-port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
