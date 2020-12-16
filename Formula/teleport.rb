class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v5.0.1.tar.gz"
  sha256 "3145e0b93c7b38fdf94e8cd995699fca8f78c26228bd19b1aad66b4749fd7719"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0974ae48535b723a3cc38cb238602a4e4bf542192c85e5a3c7487248863a69d4" => :big_sur
    sha256 "fcab18d54a2f2cd6cf4fd2ae24123f58517620bc94fd807249ee3575e81e00b4" => :catalina
    sha256 "6d71dbf63fdd7c5019a15c701d211951aa330a610d17b256fadc1e5c3852e5d5" => :mojave
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "zip"

  on_linux do
    depends_on "netcat" => :test
  end

  conflicts_with "etsh", because: "both install `tsh` binaries"

  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/72412062d6d55ec7faa9707abf500d703e7d09da.tar.gz"
    sha256 "c84767bea0a723f406e3b6566a0a48892758b2e5f3a9e9b453d22171315fd29d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"webassets").install resource("webassets")
    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
