class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
    :tag      => "v0.14.0",
    :revision => "48f9ace3ab7cb21179a43d05c328b02b17f31489"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c9b9cfaf27f24e6011277f5a37ef9292ffeaa9bb53561b5223cd8796c071660" => :mojave
    sha256 "fcbe634904119d23eb304dfb3a96973eb60721a65163b782c919a2eebef60a8a" => :high_sierra
    sha256 "893841a3fbe74d09346c360f38c95c9e534a51604e9a9f834cd1fb86cfe3473c" => :sierra
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

    assert_match "stolonctl version v#{version}", shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "nil cluster data: <nil>", shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "stolon-keeper version v#{version}", shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-sentinel version v#{version}", shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-proxy version v#{version}", shell_output("#{bin}/stolon-proxy --version 2>&1")

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
