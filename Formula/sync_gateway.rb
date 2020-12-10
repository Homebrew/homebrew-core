class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway/current/index.html"
  url "https://github.com/couchbase/sync_gateway.git",
      tag:      "2.8.0",
      revision: "61ca30a14f10edf40a26f7b2189c962c16a04b8a"
  license "Apache-2.0"
  head "https://github.com/couchbase/sync_gateway.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0ef1cc1e395235f91e764036711e8ae2027c3f30fde86f1396b885d81f377866" => :big_sur
    sha256 "3e4caa9429a0d2274e8c2ffeec79081a043a6c5c0ebba19c5f8c0fa338cfe9f3" => :catalina
    sha256 "47a1cf6e49bd6d477d9c41a5296a8362f5a576ce868ead4239adbf5297d7cdc4" => :mojave
    sha256 "03325c7a870a032d3ec25877aab7da989bf6212cb5329e61625d8624d9b1f672" => :high_sierra
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

    git_commit = `git rev-parse HEAD`.chomp
    manifest = buildpath/"new-manifest.xml"
    manifest.write Utils.safe_popen_read "python", "rewrite-manifest.sh",
                                         "--manifest-url",
                                         "file://#{buildpath}/manifest/default.xml",
                                         "--project-name", "sync_gateway",
                                         "--set-revision", git_commit
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
