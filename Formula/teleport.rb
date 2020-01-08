class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v4.2.1.tar.gz"
  sha256 "e9c515bd3dd5e85578d8f021b648d9ba008fecf4617a0bdab6190ee896d9cc2d"
  head "https://github.com/gravitational/teleport.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a33d926efce6c084f0e956e4ea9b9b64e95a62aba2756c60e41744abd585f5b9" => :catalina
    sha256 "cf3819dd816dc52b1095ae0c1f885b46dd4905bfe4bef6a982e50ef412820387" => :mojave
    sha256 "2b26a15fd9ce95cfbace1d017490aa725bdac82b1861c55b4798dcfb46592b0b" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
      prefix.install_metafiles
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
