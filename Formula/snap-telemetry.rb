class SnapTelemetry < Formula
  desc "Snap is an opensource telemetry framework"
  homepage "http://snap-telemetry.io/"
  url "https://github.com/intelsdi-x/snap/archive/1.3.0.tar.gz"
  sha256 "0b5cd4b3cc435c3ffe2944a139a0a3cff1fe811a225f6484397ad00dbbe3394d"

  head "https://github.com/intelsdi-x/snap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d689d1775a80eeedcaa54532ada9bedea5f502965b7e08ddc447ddf7c2f95f64" => :sierra
    sha256 "95bca4ded6e2ef30d4bfb125afddab4ebc211627d983aad3f5955f253bdb882a" => :el_capitan
    sha256 "c80213b060a7b825ebd7ae0da8b3e3151fa1c735b82e64af611b137a36db5aad" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    snapteld = buildpath/"src/github.com/intelsdi-x/snap"
    snapteld.install buildpath.children

    cd snapteld do
      system "glide", "install"
      system "go", "build", "-o", "snapteld", "-ldflags", "-w -X main.gitversion=#{version}"
      sbin.install "snapteld"
      prefix.install_metafiles
    end

    snaptel = buildpath/"src/github.com/intelsdi-x/snap/cmd/snaptel"
    cd snaptel do
      system "go", "build", "-o", "snaptel", "-ldflags", "-w -X main.gitversion=#{version}"
      bin.install "snaptel"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/snapteld --version")
    assert_match version.to_s, shell_output("#{bin}/snaptel --version")

    begin
      snapteld_pid = fork do
        exec "#{sbin}/snapteld -t 0 -l 1 -o #{testpath}"
      end
      sleep 5
      assert_match("No plugins", shell_output("#{bin}/snaptel plugin list"))
      assert_match("No task", shell_output("#{bin}/snaptel task list"))
      assert_predicate testpath/"snapteld.log", :exist?
    ensure
      Process.kill("TERM", snapteld_pid)
    end
  end
end
