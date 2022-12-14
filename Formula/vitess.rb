class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v15.0.2.tar.gz"
  sha256 "83a443237d244dc03ee19e76370369e331be15e9e843f1a0a10d740ea71edb4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "054272bbd5537c96beaf76ad38aa75ed4fba243904e475e64c0a0494889a1926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f38dc3f60969d75af326ce4fefa5673507a56212fa68600e788e71f18b88fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88eb89d71b07ecc22443a7cc174a63ddd7dc612567d0c8a0a677425362d1be0d"
    sha256 cellar: :any_skip_relocation, ventura:        "a556830941563b5effa10711f06b15e9c52350b7b51a3aa1236d64240c114bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "62b959efeee3feb16787dab4664a26b09dd2b90ca5cecd011ffef510f91f1da8"
    sha256 cellar: :any_skip_relocation, big_sur:        "52bbadbf719417234fdb8a6fef70a7fda2f4093077b59ea4bbb96afcb1d81fd3"
    sha256 cellar: :any_skip_relocation, catalina:       "2861d38d75ec15816b24bff4c03af7e74237a00ddc63451e99abe0fd8b3d536c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41683987278cd0ff2c6b7810e0c45ee18cdd190f059de14b126ff9cf48d1c032"
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
