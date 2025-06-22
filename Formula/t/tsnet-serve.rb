class TsnetServe < Formula
  desc "Expose HTTP applications to a Tailscale Tailnet network"
  homepage "https://github.com/shayne/tsnet-serve"
  url "https://github.com/shayne/tsnet-serve/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9c385247863f2f75a14acd8d9c758022104099bb3786af815002035746aeb56d"
  license "MIT"
  head "https://github.com/shayne/tsnet-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8d0695c024ea24eab8ade9740ac5d96065d1a8398d854e501c5091bb440127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ab5b73daabbad4132d88f8cc621a7fb4013e7c17d5aaa78cef976e965c6d8e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c7900fd179c02cedae2c84b9b6d31061e664765509143c38b6f47098a4f6809"
    sha256 cellar: :any_skip_relocation, sonoma:        "7be21bdd228c27b326dedc4c4120d1460618fd062af2178eede6b4b19b5458a6"
    sha256 cellar: :any_skip_relocation, ventura:       "9f41448fa4d33ea24919013dd2079279724fc8a7c5ec50c2baf5f77663dfd3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960f51f47faaff74445b535c61b5cf6cba1282110e11f4a3de6e49f167245e54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsnet-serve -version")

    hostname = "test"
    backend = "http://localhost:8080"

    logfile = testpath/"tsnet-serve.log"
    pid = spawn bin/"tsnet-serve", "-hostname", hostname, "-backend", backend,
                out: logfile.to_s, err: logfile.to_s

    sleep 1

    output = logfile.read
    assert_match "proxying traffic to #{backend}", output
    assert_match "tsnet starting with hostname \"#{hostname}\"", output
    assert_match "LocalBackend state is NeedsLogin", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
