class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag      => "2.5.1",
      :revision => "3f5ce5d498359d819dec9a2ebed09ff2d1be0713"
  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf26eb59ee103939923cf2230adb5ec1d522f354de2ef53dc309eea4b355344b" => :mojave
    sha256 "b69f32e1bf65fda15a11b6b686018db1ad76ae57200249b7be1759ea88801881" => :high_sierra
    sha256 "be769703edf80e9d4f553dac83bcf3d6a766564badb791b1b3de84ce53c21abb" => :sierra
  end

  depends_on "gnupg" => :build
  depends_on "go" => :build

  resource "depot_tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        :revision => "b97d193baafa7343cc869e2b48d3bffec46a0c31"
  end

  def install
    # Cache the vendored Go dependencies gathered by depot_tools' `repo` command
    repo_cache = buildpath/"repo_cache/#{name}/.repo"
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
      ENV["SG_EDITION"] = "CE"
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
