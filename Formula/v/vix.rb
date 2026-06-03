class Vix < Formula
  desc "AI coding agent"
  homepage "https://github.com/get-vix/vix"
  url "https://github.com/get-vix/vix/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "04ea72e27e3d0022432221af7bb65665c0541c35804cb0453822949c75a30376"
  license "AGPL-3.0-or-later"
  head "https://github.com/get-vix/vix.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vix"), "./cmd/vix"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vixd"), "./cmd/vixd"
  end

  service do
    run [opt_bin/"vixd"]
    keep_alive true
    log_path var/"log/vixd.log"
    error_log_path var/"log/vixd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vix --version")
  end
end
