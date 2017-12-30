class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag => "1.3.1",
      :revision => "660b1c92fadce1a9c7e692dfe7c5b741772d1dd2"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a5b069076f54e606c30b2c01d4e3e66e136c10b101d94ce615c924964d358eb" => :high_sierra
    sha256 "cc2e8b1e7e5145681ff264d3d7fe53445ae01331420221a833e148dbe8126192" => :sierra
    sha256 "1f72bc0d2674b891e8107d3c6fc21a13d6d86e47ba5077eed63245735e31ac7e" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "gnupg" => :build

  resource "depot_tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        :revision => "935b93fb9bf367510eece7db8ee3e383b101c36d"
  end

  def install
    # Cache the vendored Go dependencies gathered by depot_tools' `repo` command
    repo_cache = HOMEBREW_CACHE/"repo_cache/#{name}/.repo"
    repo_cache.mkpath

    # Remove for > 1.3.1
    # Backports from HEAD the upgrade from Git protocol to https
    # See https://github.com/couchbase/sync_gateway/commit/1cf0399
    inreplace "manifest/default.xml", "git://", "https://" unless build.head?

    (buildpath/"depot_tools").install resource("depot_tools")
    ENV.prepend_path "PATH", buildpath/"depot_tools"

    (buildpath/"build").install_symlink repo_cache
    cp Dir["*.sh"], "build"

    git_commit = `git rev-parse HEAD`.chomp
    manifest = buildpath/"new-manifest.xml"
    manifest.write Utils.popen_read "python", "rewrite-manifest.sh",
                                    "--manifest-url",
                                    "file://#{buildpath}/manifest/default.xml",
                                    "--project-name", "sync_gateway",
                                    "--set-revision", git_commit
    cd "build" do
      mkdir "godeps"
      system "repo", "init", "-u", stable.url, "-m", "manifest/default.xml"
      cp manifest, ".repo/manifest.xml"
      system "repo", "sync"
      system "sh", "build.sh", "-v"
      mv "godeps/bin", prefix
    end
  end

  test do
    pid = fork { exec "#{bin}/sync_gateway" }
    sleep 1
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
