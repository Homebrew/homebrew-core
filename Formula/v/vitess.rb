class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v17.0.3.tar.gz"
  sha256 "ac7af4f539b189d7258a6b159fe4399196be6ed2045d652ad79bb96d8a0b9028"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c546366d329e3bd45da1024cfcbf50307c57a6bc687160e735b9b505d1f2927"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2592f639825477c2d2895bc61a57a1aaf1b42fcada97d402cd32b25bf3fa77fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b8df908c622b2fd1202457607b8cb27f5af6ddee3030191815f7d641ddc5cbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "263f0b864278da047219faf8373da64c901b07eb73a9cede6eaa5baf5d54c0d1"
    sha256 cellar: :any_skip_relocation, ventura:        "6e03d078aca1a13162e6fdc82c50dfac8fe152e92569afc69ab60d9295bf6ace"
    sha256 cellar: :any_skip_relocation, monterey:       "74e5ca0e3769be1eaaf34265195f55af27a9fe2f40d0a0d91c8a125ce086f1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359f57ce551444911fd964e107156919d82e2ee2a919e96786039ea366cfe7c1"
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
