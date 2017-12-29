class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag => "1.3.1",
      :revision => "660b1c92fadce1a9c7e692dfe7c5b741772d1dd2"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd315bdb4dda4fa27872982e72d77015797074e3962e6953c45670737ad130f0" => :high_sierra
    sha256 "6146d1292fb02687ed738bbd8bf5e265d1b55462caf15914d056202236cecf16" => :sierra
    sha256 "d9db8238a572c9b27cfa9b986c7ee06af922da0fad68882d177e270d6f2b5637" => :el_capitan
    sha256 "35a9b9ff4fe60cc0504cac69ba38b16031ca76eb4fe63938f1a2f5379c34baa5" => :yosemite
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
