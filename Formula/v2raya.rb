class V2raya < Formula
  desc "Web-based GUI client of Project V"
  homepage "https://v2raya.org"
  url "https://github.com/v2rayA/v2rayA/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "6d203ef95ac2a48f6f1808b93fc1cd1a4f32a0419710d0c7a74169f27c38ed9c"
  license "AGPL-3.0-only"
  head "https://github.com/v2rayA/v2rayA.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build
  depends_on "v2ray"

  def install
    ENV.deparallelize
    chdir "gui" do
      system "yarn"
      system "yarn", "build"
    end
    cp_r "web", "service/server/router/"
    chdir "service" do
      system "go", "build", *std_go_args
    end
  end

  test do
    ENV["V2RAY_LOCATION_ASSET"] = "#{HOMEBREW_PREFIX}/share/v2ray/"
    port = free_port
    v2raya_process = fork { exec "#{bin}/v2raya", "--lite", "-a", "0.0.0.0:#{port}" }
    sleep 5
    system "curl", "-v", "http://localhost:#{port}"
    Process.kill 15, v2raya_process
    Process.wait v2raya_process
  end

  service do
    environment_variables V2RAY_LOCATION_ASSET: "#{HOMEBREW_PREFIX}/share/v2ray/", 
                          V2RAYA_V2RAY_BIN: "#{HOMEBREW_PREFIX}/bin/v2ray", 
                          V2RAYA_LOG_FILE: "/tmp/v2raya.log"
    run [bin/"v2raya", "--lite"]
    keep_alive true
  end
end
