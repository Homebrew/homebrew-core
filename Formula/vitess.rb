class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v13.0.1.tar.gz"
  sha256 "26ebde8cd2720006510c573370fd6d77d5a573ea54e5e49e21c70906758775f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2018e69275a46fb6acb3fbd9014322f4eb18eee96c7c4c3455544e9f3bb1d66b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0025ffff025a0bc614a6708419fbb7f352d38b0c2e501e55b25160385e3fdb31"
    sha256 cellar: :any_skip_relocation, monterey:       "21860e27b898b30fc78272501636baab3591a57c48f18771eb7630df44571102"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3142f92f0b868718f8f148f802c0cc2a27f64711bead1d0f9fd736e3f9520ee"
    sha256 cellar: :any_skip_relocation, catalina:       "ef82f191d88d14d52e38d34f766cf06116b80596d48d372c100be43945d88352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "983cfa02a334e29f09277d248b59bd35f977e5991bebe74a118ca0725fa7d740"
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
