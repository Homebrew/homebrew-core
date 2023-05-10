class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v16.0.2.tar.gz"
  sha256 "89328d683f2694de4ada21c7a815d396a853ad45d39607aca467996678b69e0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a5e91bca36b3f779377d4793dcebb6b7173659a532742aa9b91e6c54b2e100b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c5d7ff2c979baf31376c2c957b43e55ffa3f20e1d74f116bfd10ce868e916e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b08791bf5a555b94b6e61aaa1a867418fc14866e1dad96dd1384ce5e01204219"
    sha256 cellar: :any_skip_relocation, ventura:        "e5f6787ac995320015e39c18aa3177647363c13ae04712c085adc66841550663"
    sha256 cellar: :any_skip_relocation, monterey:       "415a75f0f17bad8dc7b2ca91fb4326fc4c16a6c0f5ff4a123789fc29d58a3657"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd4261ad2b884af15ada1e042b1b907a3f7841bcc69f865eb1c5902b3ef66f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74433e4db646176d83502c121c735089f05b9f202f88080eea566cfdcb2c2a7d"
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
