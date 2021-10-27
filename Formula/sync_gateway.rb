class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway/current/index.html"
  url "https://github.com/couchbase/sync_gateway.git",
      tag:      "2.8.2",
      revision: "4df7a2da36c88a72131b23eb044b7d0b69b456bd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/couchbase/sync_gateway.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50c85b6d34732db590c9ae22485cdf050513739ea731eed8655637eeb39b5265"
    sha256 cellar: :any_skip_relocation, big_sur:       "2844109c176adfcb04733a42e9d687998f21a693ac2876ee7246f4d5d9c353d9"
    sha256 cellar: :any_skip_relocation, catalina:      "74e1a9478cf47b90b6988cac007091b36a455e107b7a96e7c949abaefabfc835"
    sha256 cellar: :any_skip_relocation, mojave:        "7628b353af0ec25e578ff6a20b9e0eb7892902b484d5f2bd039bda3f0e1a7bb3"
  end

  depends_on "gnupg" => :build
  depends_on "go" => :build
  depends_on "repo" => :build
  depends_on "python@3.10"

  def install
    # Cache the vendored Go dependencies gathered by depot_tools' `repo` command
    repo_cache = buildpath/"repo_cache/#{name}/.repo"
    repo_cache.mkpath

    (buildpath/"build").install_symlink repo_cache
    cp Dir["*.sh"], "build"

    manifest = buildpath/"new-manifest.xml"
    manifest.write Utils.safe_popen_read "python", "rewrite-manifest.sh",
                                         "--manifest-url",
                                         "file://#{buildpath}/manifest/default.xml",
                                         "--project-name", "sync_gateway",
                                         "--set-revision", Utils.git_head
    cd "build" do
      ENV["GO111MODULE"] = "auto"
      mkdir "godeps"
      system "repo", "init", "-u", stable.url, "-m", "manifest/default.xml"
      cp manifest, ".repo/manifest.xml"
      system "repo", "sync"
      ENV["SG_EDITION"] = "CE"
      system "sh", "build.sh", "-v"
      mv "godeps/bin", prefix
    end
  end

  test do
    interface_port = free_port
    admin_port = free_port
    fork do
      exec "#{bin}/sync_gateway_ce -interface :#{interface_port} -adminInterface 127.0.0.1:#{admin_port}"
    end
    sleep 1

    system "nc", "-z", "localhost", interface_port
    system "nc", "-z", "localhost", admin_port
  end
end
