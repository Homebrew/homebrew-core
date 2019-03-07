class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git", :tag => "v0.13.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8ef622f0b90477eaf3231563a82738c28e59f7b4ff3e82cb24923552f8b5dce" => :mojave
    sha256 "5ce46f6fa94f1cb1e9605f4a3aa3fbb17debb2658ca465a1edb469c79caf34a3" => :high_sierra
    sha256 "c51cd775f84ea6a00dd7fde28bb6c917c25f8c909e57faa838e4e7b0b541fb30" => :sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "postgresql"

  def install
    contents = Dir["{*,.git,.gitignore,.github,.travis.yml}"]
    (buildpath/"src/github.com/sorintlab/stolon").install contents
    ENV["GOPATH"] = buildpath

    Dir.chdir buildpath/"src/github.com/sorintlab/stolon" do
      system "./build"
      bin.install Dir["bin/*"]
    end
  end

  test do
    pid = fork do
      exec "consul", "agent", "-dev"
    end
    sleep 2
    run_output = shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "stolonctl version v0.13.0", run_output
    run_output = shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "=== Active sentinels ===\n\nNo active sentinels\n\n=== Active proxies ===\n\nNo active proxies\nnil cluster data: <nil>\n", run_output

    run_output = shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-keeper version v0.13.0", run_output

    run_output = shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-sentinel version v0.13.0", run_output

    run_output = shell_output("#{bin}/stolon-proxy --version 2>&1")
    assert_match "stolon-proxy version v0.13.0", run_output

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
