class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v16.0.0.tar.gz"
  sha256 "67f864d4e5e9a6b248e9e8edaeae7a02dd821f1e9295865d910a697cf0443eb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3ebcfbec10f2f797b56cd651239bff6d9c4d59955745d2fe1edca565e35bc81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c621d9f338c99c3afb9a83fcd4fcf929378de6f38b2ebe6d07037d8c2c7eb33e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "240d701595519687b7b18e83f4a0bdcdabb5465eb84a4875278fb5833d5f333e"
    sha256 cellar: :any_skip_relocation, ventura:        "90a5c931e6196d017fdb6e1a081f412ac7e88c667d6c56453731ad4f70305ab4"
    sha256 cellar: :any_skip_relocation, monterey:       "609c5a52614b14be3a0403d2fb6bb6186360cc4620df11fa6fa0df2859ab776d"
    sha256 cellar: :any_skip_relocation, big_sur:        "26c95f69d22fe503e3e11c162c9eab925e6c6c02dbf7a5dbb59e08289a23e85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4312ec085eccf3ce6fb6e818b92822d53e3a18e50482d9660e10a9a851550a4"
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
