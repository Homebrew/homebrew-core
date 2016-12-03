class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag => "1.3.1",
      :revision => "660b1c92fadce1a9c7e692dfe7c5b741772d1dd2"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec6f97bbc7d3afeef7bc7274d93a2a89e4d51fd04eb64882295537aa46f407c6" => :sierra
    sha256 "d2885b854b63c1acf88918a29122bbd26383f80001e9f5f6cace389d189df24e" => :el_capitan
    sha256 "ee84b69ab0eeedc05fce8b24879414c539d31418aba1ad32a4e59bf8ccd73e9d" => :yosemite
    sha256 "a49e6035c48b7117c3b3f672cc50b928878f9c0b04a6529d02dabd0397c5c0ff" => :mavericks
  end

  depends_on "go" => :build
  depends_on :gpg => :build

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
