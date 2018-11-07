class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag      => "2.1.0",
      :revision => "a036bd817d35ff1c354c644804dc588fb7c41476"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9960ef9eb77e0e98e136cbb90de2704c533f6238373a0acc0aaf11c9d66e7454" => :mojave
    sha256 "e1500abaed4f0db1aae20b00766eb1634bcaea6a2c0c0c8ee9860f95799e89c1" => :high_sierra
    sha256 "460dd8e306588c106283b108cddcc9097095e12ef6f53808515d7b0255a9b8fe" => :sierra
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
