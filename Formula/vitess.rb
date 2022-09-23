class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v14.0.2.tar.gz"
  sha256 "a29eb7cab925e2121a93d65748e3022c3e3093267f85110e34b0f8de9fa11b8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0941341f66d3a6080acec1ae051ba41a23eff2920d0b5ea28613010f7944fb3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e42569bda5970732c90ca421f54dbff1fd0566f62f604c518fdb0c9aa0db9969"
    sha256 cellar: :any_skip_relocation, monterey:       "874b8f51b421951bed01a7285aafc483dd13d2871cb92a0b96993c2cffe5b294"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cf46a0e20c4f013a4bf4901da4e3c80ccc596cf9f038cdd1e2cb3ec32a81494"
    sha256 cellar: :any_skip_relocation, catalina:       "6af3734265dac7fd2ec6b9968a83040a20a393ae2952886628695ad1e5401c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d5ae2c2119d207909bdbbecd04daa992418764fb08db9263e422b689e9a7ae"
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
