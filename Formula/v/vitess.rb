class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v21.0.2.tar.gz"
  sha256 "6228b7c9f767ab34edaea33b4f25460a042422793a029e674325f39bebde380a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ee89ed14e685900565932769fd62b185584b6556348858d520916262e6b60b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cda6548eac2490a38ed5af71a630d09fdb6609dcf6a6109172dc6d20a9068e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "579ea43818e3ca28142daf9c5fc4fd131cb9dfb88e8625ad5fb9660b6aaffd44"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3eb6643d817dc2a126d86ebb7353ec8b4b858551e1a8c269e1608deb08c674f"
    sha256 cellar: :any_skip_relocation, ventura:       "e265e612b65e41fbbd564db22404c1c4a3fc558c64741597f9536e11b22359b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03fdeaefeba69c5249126d51468e449253aa4e784c0f7b7a0424fd0e791cd28c"
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
    sleep 8

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
