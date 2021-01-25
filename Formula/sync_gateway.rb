class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway/current/index.html"
  url "https://github.com/couchbase/sync_gateway.git",
      tag:      "2.8.0",
      revision: "e2e7d4286f84e3d101e2ea0d9ee868c66e6243f1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/couchbase/sync_gateway.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1eb668b81243fb12bcbbbacae732a90a03afca24977b00e8ad25b3eab36c564d" => :big_sur
    sha256 "c433c7310d089ff0399ba66e3f35aca60a5663f207d9b23e95069f0d5dd6e397" => :catalina
    sha256 "f352f303e22c12d87faa8e5748bce4b33fa831a88b30fb744a4f7e011296fa8b" => :mojave
  end

  depends_on "gnupg" => :build
  depends_on "go" => :build
  depends_on "repo" => :build
  depends_on "python@3.9"

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
