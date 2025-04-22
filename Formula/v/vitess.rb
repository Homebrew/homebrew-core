class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v21.0.4.tar.gz"
  sha256 "89195359cae79d4d0fb2cb5dda5fb809dca6695d544201cebe812734e14b6967"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc433238b9a199040cdb0cc18690e6b7d4273c819b417054979ccb403f44552f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26d52dcbe9bb31d0371e2ecd39a46665d624aa70bb7bdb6b15e210c2221e8355"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5431ee952a1a37de1e337fc6a3af9a92f699b8ab584f4f63dbf54ffb77de59c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "68005d72663c7e9670bbb7aa770d028e2b4ec03e9ab138b0e989dcfc7e30fe1c"
    sha256 cellar: :any_skip_relocation, ventura:       "112ac22edb61155289b059946a032a440c6f78a65e5e48f55187d97cf67d019a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e39d94baae43c33f3657e8c58e4d61c67f34310fa8579580f5ff07d984b62dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1dd0d40a1d858e0be02e26da60ae7aa9fc1ef989f8cbab45503a46364f22ae"
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
