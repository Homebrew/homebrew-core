class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v4.1.1.tar.gz"
  sha256 "a33b958084fb68f10a7ebf800030c70c6542b1c3eb61d5f6826a87710a609f8c"
  head "https://github.com/gravitational/teleport.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "978b23a23a158a38e6c0cf077b7feeb7836a35d4f8811036e7daf495312a4706" => :catalina
    sha256 "3193ea574dfd40ca9edce1c4fe92ffe22faf0235c7020c6c41e6eef266a90353" => :mojave
    sha256 "d5faf8f14d241f4065d0a950b63258dbe9b14677f8333eb8125d204fa4ab8212" => :high_sierra
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
