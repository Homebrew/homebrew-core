class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v19.0.3.tar.gz"
  sha256 "7040ec592fef5ecba87e9f629dfc9df9a9ac20d634dd2669bf88c857be160add"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "278c269eb6be3f0d08028f2d4b6e550a93ec93d2fe0420179eee579daeccd0c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "776f3bf573e7a26b3b71d6ebc0e171d8948e48cc3765ba16b0e45eb7b57812de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b9d261593020f4f965ecb5fe640220d8b958ea33ddb754a33937f3ac8b65e33"
    sha256 cellar: :any_skip_relocation, sonoma:         "9deab68bde2525f8adb9db96c3df9e9d7fe7429fb77daefc183dcd041994fc81"
    sha256 cellar: :any_skip_relocation, ventura:        "4f843dd857ab9a6bb6a8764a213bdf40185ae07b0554eb545e74cd284708007c"
    sha256 cellar: :any_skip_relocation, monterey:       "4a01d6a8eec5917942ab4081afbba170162fe83c924cf375552acc2fadabe4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5e16d17847c69fef9802acc75b37b53f368c7cbc25bb17595d64790c8763140"
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
