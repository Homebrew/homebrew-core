class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "https://docs.couchbase.com/sync-gateway/current/index.html"
  license "Apache-2.0"
  head "https://github.com/couchbase/sync_gateway.git", branch: "master"

  # NOTE: Do not update to v3 or later due to incompatible license
  stable do
    url "https://github.com/couchbase/sync_gateway.git",
        tag:      "2.8.3",
        revision: "e54a62741bb28f3e54a6599c21c739df9a9dad76"

    # Backport fix to build with Python 3
    patch do
      url "https://github.com/couchbase/sync_gateway/commit/97279d5ff172c1535bd4df764fbc51029d003b53.patch?full_index=1"
      sha256 "ffae5adc94868e9512173ea596a0018cc436767687b097dfd8c5ba85a9fae097"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc30a79633112d1c6a18e6632f4b1ed95fd78495aba2d8ecfd8fb0f36722dad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8db243a62dcdd2c9c6b1ddd9bf61ad0072e4ac395b208822fd254077d6973d75"
    sha256 cellar: :any_skip_relocation, monterey:       "8d97b3bd4148de64835b723feb06d3718b6606b941b9c3661dd464495c3c392a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bd988cfdd72c00a76eae19e4c347ae79b0c597e34a551add01318fa71645b9b"
    sha256 cellar: :any_skip_relocation, catalina:       "ad754927fbbec6adc9b31cb726a0457f62719bdfa546260eb768b402b9257bda"
  end

  # v3 switched to Business Source License 1.1
  # Ref: https://github.com/couchbase/sync_gateway/blob/3.0.0/LICENSE
  deprecate! date: "2023-01-03", because: "is switching to an incompatible license"

  depends_on "gnupg" => :build
  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on "repo" => :build

  uses_from_macos "netcat" => :test

  def install
    # Cache the vendored Go dependencies gathered by depot_tools' `repo` command
    repo_cache = buildpath/"repo_cache/#{name}/.repo"
    repo_cache.mkpath

    (buildpath/"build").install_symlink repo_cache
    cp Dir["*.sh"], "build"

    manifest = buildpath/"new-manifest.xml"
    manifest.write Utils.safe_popen_read "python3.11", "rewrite-manifest.sh",
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
