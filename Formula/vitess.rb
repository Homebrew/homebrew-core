class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v16.0.1.tar.gz"
  sha256 "30ae1c70a72a12d072b619309e886074845a72e7151815525d50745670558d3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7d39d8b7ebe30f7eb09f25093631813992905c11c2bb08a65d7982351d7a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b6375b72a19d1cd1452082c6f0043e3328fd90dc66f0fbde37ce41ce99b562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e20e1203b438bd0f288ccc53ca2d0e3272c5340701f31f31acf92344e492411e"
    sha256 cellar: :any_skip_relocation, ventura:        "2b976048b7f5d0a1cf8b98d958ba5597481f693574070ba27f61c2e39eb43e68"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a5fb6e2e21d786f12627946df8bcf83bc80043524fb3a5763979174fb279a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3d23de2844d9e985d686249eacfd544b75a65d53888fad3ca79dd7ff9e04192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a510a444380a8cc6494def3cf4c0d429251d3f3dda126f409930012d5a29939"
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
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
