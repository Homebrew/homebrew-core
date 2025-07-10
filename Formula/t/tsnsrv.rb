class Tsnsrv < Formula
  desc "Reverse proxy that exposes services on your tailnet"
  homepage "https://github.com/boinkor-net/tsnsrv"
  url "https://github.com/boinkor-net/tsnsrv/archive/e2537464e45db0f173e8e68d0316b40c13e1e49c.tar.gz"
  version "1749151631"
  sha256 "89048f6d9c3fddf5c3a2d6800de1978d439a8addf70ab1f1797b5bdc626d3387"
  license "MIT"
  head "https://github.com/boinkor-net/tsnsrv.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tsnsrv"
  end

  test do
    hostname = "test"
    upstream = "http://localhost:8080"

    logfile = testpath/"tsnsrv.log"
    pid = spawn bin/"tsnsrv", "-name", hostname, upstream,
                out: logfile.to_s, err: logfile.to_s

    sleep 5

    output = logfile.read
    assert_match "tsnet starting with hostname \"#{hostname}\"", output
    assert_match "LocalBackend state is NeedsLogin", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
