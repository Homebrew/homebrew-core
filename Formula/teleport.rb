class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.0.0.tar.gz"
  sha256 "640a66de9dd366558cb4f9725c47df46e1f109fb326a4902e739c6117f1e4700"

  bottle do
    sha256 "9c20fb9e3008148730dab6e35d0a7cd0472100793737a98d4d7c95bd0175815b" => :sierra
    sha256 "41e283da433d6623fa37b981551e631adeeda850e1835eb0a1968f64379e0f15" => :el_capitan
    sha256 "e6ad71b1359c608d3740fe0410e67e5735027170ce6908b5f283f3fe03b8d43f" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath / "src/github.com/gravitational/teleport").install buildpath.children
    ln_s buildpath/"src", buildpath / "src/github.com/gravitational/teleport"

    cd "src/github.com/gravitational/teleport" do
      system "godep", "restore"
      ENV.deparallelize { system "make", "release" }
      system "/usr/bin/tar", "-xvf", "teleport-v#{version}-#{ENV["GOOS"]}-#{ENV["GOARCH"]}-bin.tar.gz"
      cd "teleport" do
        bin.install %w[teleport tctl tsh]
        prefix.install_metafiles
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
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
