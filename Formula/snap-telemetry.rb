class SnapTelemetry < Formula
  desc "Snap is an opensource telemetry framework"
  homepage "http://snap-telemetry.io/"
  url "https://github.com/intelsdi-x/snap/archive/0.17.0.tar.gz"
  sha256 "d627eff8155b346ce542fdf3251b2713a0bae887fb6a8ef3ba169b13c4f9fc60"

  head "https://github.com/intelsdi-x/snap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d3129e1941eb33b398752a50c4cabe9b5877e8d2188b0c7076559863ee72e49" => :sierra
    sha256 "66603b621f657395f685bb9a76542f197c22971cee0d3daf34f8383d0d87d48f" => :el_capitan
    sha256 "8c9fcbb7b65556defd646e8fb884a54870bc1232142fb7231fa9099894c0dd82" => :yosemite
  end

  depends_on "go"
  depends_on "glide"

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    snapd = buildpath/"src/github.com/intelsdi-x/snap"
    snapd.install buildpath.children

    cd snapd do
      system "glide", "install"
      system "go", "build", "-o", "snapd", "-ldflags", "-w -X main.gitversion=#{version}"
      bin.install "snapd"
    end

    snapctl = buildpath/"src/github.com/intelsdi-x/snap/cmd/snapctl"
    cd snapctl do
      system "go", "build", "-o", "snapctl", "-ldflags", "-w -X main.gitversion=#{version}"
      bin.install "snapctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapd --version")
    assert_match version.to_s, shell_output("#{bin}/snapctl --version")

    begin
      snapd_pid = fork do
        exec "#{bin}/snapd -t 0 -l 1 -o /tmp"
      end
      sleep 5
      assert_match(/No plugins/, shell_output("#{bin}/snapctl plugin list"))
      assert_match(/No task/, shell_output("#{bin}/snapctl task list"))
    ensure
      Process.kill("TERM", snapd_pid)
    end
  end
end
