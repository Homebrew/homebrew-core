class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v17.0.0.tar.gz"
  sha256 "34eb14f06663efd1a67a4a8da3d7c18e3a1eb888950ce0ae4fa79d0aa7ed2d32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3da2dd850b21d024b6624f147599db5335e0724d69960908ce680baea5a0e300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4459bddf345561e292cfe8df41933ec8020c952bef41e1caf99fb90a537e5de1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86c252e7d0e5725a20354402cb121570d8422a0bd7141c0644b5c4816bc63364"
    sha256 cellar: :any_skip_relocation, ventura:        "5cfd64fef3f996c42c94cbdf3eaa5701a2631c6563cb93d4870f2496810bcc47"
    sha256 cellar: :any_skip_relocation, monterey:       "504793490b115eea935c9bd0bfb38bbbc37e5ea1f3939c26493b3f901e465148"
    sha256 cellar: :any_skip_relocation, big_sur:        "a74b91ec0ea1172cefd4d62c22c3991a7ccd0de04d1dd8b47a7ffb81e2f50149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27f2883614052f73201425f5f12c686a2f02a7e3acd04c7c3a458fcfdad6eb6"
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
