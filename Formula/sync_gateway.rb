class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag      => "1.3.1",
      :revision => "660b1c92fadce1a9c7e692dfe7c5b741772d1dd2"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "471f3244cffbe05f2ee8a6f190b498970677b801273cbf67cbdd5eb0bf8c85da" => :mojave
    sha256 "b4aab1726d93e48be305c6cc7c06a743377d1165c2622a9cbd96a262a3535c19" => :high_sierra
    sha256 "38828a19ef81effee0b3d9214cff45ef59ff069624caedf2ff87a982f03f0c30" => :sierra
  end

  depends_on "gnupg" => :build
  depends_on "go" => :build

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
