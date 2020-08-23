class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway/current/index.html"
  url "https://github.com/couchbase/sync_gateway.git",
      tag:      "2.7.3",
      revision: "33d352f97798e45360155b63c022e8a39485134e"
  license "Apache-2.0"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b1ec1b07a62ae7e15e2d16be2a10ccc18a53ba1302a8aaef1760d90046500cc0" => :catalina
    sha256 "db5e68b8cf1d359212a549ca79685f219854652421e88459c796bf27ccaf004b" => :mojave
    sha256 "7efcb17eada7400912053e7fc0e4851d2f3346278238f6be3bc3a854af6ee339" => :high_sierra
  end

  depends_on "gnupg" => :build
  depends_on "go" => :build
  depends_on "repo" => :build
  depends_on "python@3.8"

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
