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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abb762a9ab0adb5d448fe772eb16320889107513e1e3b8ffa96d8f906955f1f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eeb4fc96bdbbe45ebbe3697a6b66c5af1fb669d838641f3f4196e25c0347776"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e6c262ca1813ad780e52198b11aaa3756ddf070a2979185406a6e0114782d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c73fc61bd3b98f2d5a16567207e53292e923782eb03368749540b543683d37e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fecd6d239da03e4d2361259c8068a26115541411b422317a1e7b5992c455295"
    sha256 cellar: :any_skip_relocation, ventura:        "a1ae675bdd86d4dff95de1a3fa840c582cd3ad308615e150ee91d0e9d296af24"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7a3017185bb88be88d29956f01940ba8bcab4b2662295fa92e62e224aeb35f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e32ee39b28d597b25f950b27cfb14b306db52fd752f855cab27d0a994271277"
  end

  # v3 switched to Business Source License 1.1
  # Ref: https://github.com/couchbase/sync_gateway/blob/3.0.0/LICENSE
  disable! date: "2024-01-12", because: "is switching to an incompatible license"

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
