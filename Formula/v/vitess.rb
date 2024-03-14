class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v19.0.0.tar.gz"
  sha256 "71e67b8047af40d9954ad09f15f6d91e784dc0258788850c3fd29b9fae8b6151"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5debaf659ebed1caa383c5812daf7b64963b95bbc0ea7be111c64f7cd1e3fccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07c430b8469b4b1a562e135c361962f52a054cc77eff40d17e9ccdb0f7d192b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16e4a6023d18e131ef55ade952f0282a1e2b2e3d4c2e35ded966f7e678f1cb48"
    sha256 cellar: :any_skip_relocation, sonoma:         "32fc693db6a00202d74b063f6a0f966cff72aa7a6d5b3ce0151c74415b115f86"
    sha256 cellar: :any_skip_relocation, ventura:        "8ddc835981df51c1f617f65a75745b43768f0438b3aae944061352f06491142c"
    sha256 cellar: :any_skip_relocation, monterey:       "0951f5a9a2e26a4fa0da5eae7bb88707704d119ad8749569d0c36da6a728373c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25c9152195cc64594f550a1838aec9cd83f22d8eebf0dff6aaca472ced7461f2"
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
