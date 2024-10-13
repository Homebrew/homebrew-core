class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v20.0.2.tar.gz"
  sha256 "64a56c3c7eb9466ae87ccc6eea9a56732c45564ac16efb05e3c4e4885ffea94d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e12f16ab66ecb5050e6cba2d1c7aa1c5f5a96bb452ac38fa72eb1a05604995f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30ba606e9be4b209ce827534020d48913f8480a5d2624e0b6be1b0350174ac4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaeeb1346074a8298f6cbe7276019785149988aa429c62793609dc61dcaa60c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ad57b8f34f78d1bf2d0eb00f3f3ee9d53f38d9e32a90a18ec6d7f7de1082916"
    sha256 cellar: :any_skip_relocation, sonoma:         "9caad1c737e80cdcac44718a5a66f8c3a2567eda7db37f0666d774687919af72"
    sha256 cellar: :any_skip_relocation, ventura:        "d40d954db36101dea8e525b7a2f63c4c4a6ec96e66cd9581126282e941b8def1"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc0343d05d64c3bf72bc779530f7b9eedf1f7841ebd756ff326881ec6b16e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4d1b8105de7f48ab3df1f117ba42655208052dad83e2fcd6abac5e05d08eda"
  end

  # use "go" again after https://github.com/vitessio/vitess/issues/16015 is fixed and released
  depends_on "go@1.22" => :build
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
