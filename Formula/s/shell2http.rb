class Shell2http < Formula
  desc "Executing shell commands via HTTP server"
  homepage "https://github.com/msoap/shell2http"
  url "https://github.com/msoap/shell2http/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "17fab67e34e767accfbc59ab504971c704f54d79b57a023e6b5efa5556994624"
  license "MIT"
  head "https://github.com/msoap/shell2http.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4afb529539a1b571d671848f86b8338041aeb67f917f45176e3220be20e63537"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "791d24266a7c357bb2c00ee4f04714646980b607d58993ebe6b43f5a119e9b64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f3cc864755a4ded46ac897aa8bb5cf0fd9546fd1d84676182246a4c35534a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "93fb449677f5f9e84184c01c7022127439190c03ab93a72c92da1e75c8f46992"
    sha256 cellar: :any_skip_relocation, ventura:        "8c9c13e2334150a5cbfc7dd976c4bf46203fdaeb0d58cd7ab6923eb38efa0f82"
    sha256 cellar: :any_skip_relocation, monterey:       "fa7b359bfb0188cbfdd5d08a7b78924f4b186456706e10c7c2fb80931bcf07e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fe4bf67a183748096c5bfaa8d90677dcff799a9fc847f78ca8a733645b68cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    man1.install "shell2http.1"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/shell2http", "-port", port.to_s, "/echo", "echo brewtest"
    end
    sleep 1
    output = shell_output("curl -s http://localhost:#{port}")
    assert_match "Served by shell2http/#{version}", output

    output = shell_output("curl -s http://localhost:#{port}/echo")
    assert_match "brewtest", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
