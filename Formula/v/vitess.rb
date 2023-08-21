class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v17.0.2.tar.gz"
  sha256 "a7f32da038c04b35d5b51ceef8210de8159267467ea4aa5fe14bd144975d5511"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c831c8b45af7f2166ea2d5dd14245f2388de94bad3ea7e11597952b3fbf20710"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21f4ed8033b1d286b6c276dda0cb68eaeb43f5dbe55397173637b7588a78790f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c7fb08c2d8d2244d9a65f71671fd83afb00c3949341dd146a3dfac72e0bdf61"
    sha256 cellar: :any_skip_relocation, ventura:        "5dba5bfd643d7ec3a4ba70b6af492438e2f04596e15913e9350119b74a66a930"
    sha256 cellar: :any_skip_relocation, monterey:       "ba52cb2ed6c7e61992c72e1e7c8823acaf6db545fcffb5086f66d5f5e353c07d"
    sha256 cellar: :any_skip_relocation, big_sur:        "59b6fbb95fd1cb61fa2de833e8cbf314c4dd776e49ccd0af928249da2b4dd0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbc0ad5461a1fce055c1a31ce5b3ae148a5b9d7c6439937704913da118acc95"
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
