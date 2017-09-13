class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.2.7.tar.gz"
  sha256 "ae56ed34c1ecb9e5e4c07d5a2216a246eb68f9a7a62b888213a8d1b95f2c2f0a"

  bottle do
    sha256 "acf4ed9b1b2dbcf605862120980cc96a49d386ef2b571d3c4023a75c4b02a67b" => :sierra
    sha256 "7ee92c34ab07570b22787e47bd5796e170eff7115bdf2c2d2977218c669d5229" => :el_capitan
    sha256 "c6736afe21b6a3f584a85308758c4c16fb29e687b5aefc9386479b5c25ddfe7d" => :yosemite
  end

  depends_on "go" => :build

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    # Reported 28 Aug 2017 https://github.com/gravitational/teleport/issues/1229
    inreplace "Makefile", "2.2.6", "2.2.7"

    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath / "src/github.com/gravitational/teleport").install buildpath.children
    ln_s buildpath/"src", buildpath / "src/github.com/gravitational/teleport"

    cd "src/github.com/gravitational/teleport" do
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
