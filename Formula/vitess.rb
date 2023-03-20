class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v16.0.0.tar.gz"
  sha256 "67f864d4e5e9a6b248e9e8edaeae7a02dd821f1e9295865d910a697cf0443eb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fe2b2173fa7480175e1db8fed436f7bee2f050cb5957d01e25b7abfb98c79aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50283ea90ffb89aa714d86fbc8e787745603bffe289b60c231f82766eb0abf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e99ddbf48ea2738a5d906037dd9cbbd9d642f2eb4528565dffdebdd9860addf2"
    sha256 cellar: :any_skip_relocation, ventura:        "4d7bf9b2164249177ed3548d617f8aef7a26acc3432a444b3b0d1a0586985783"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a4f4e44f88bd9376381e68fffef513214eace266633b8aca3bd3a129428505"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c0e73eb3e47b16f637bfc9fa3d0294cd457c177e74ee3372b893b62949165ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51b295628b8db317ed64d129728bbd7a34ef35b5caf6ed4105ca2b813fc77c9"
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
