class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.5.2.tar.gz"
  sha256 "84d637c848a173113ddb49437ca7bc631525ce96221c25a2b4b6f1dba86570a2"

  bottle do
    sha256 "aa091e712543662a57e86bab8aee336b1a7a954e71a795c6ad621f019a1bf725" => :high_sierra
    sha256 "7357250104bb37502623f063406a581083270e90c7756dcb67e8140abe28677d" => :sierra
    sha256 "d1d273066d8cbf0ccbe1030fb4d23656f64541533407c16e048849b20f69c2ed" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    # Reported 21 Feb 2018 https://github.com/gravitational/teleport/issues/1708
    inreplace "Makefile", "-j 3", "-j 1"

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
