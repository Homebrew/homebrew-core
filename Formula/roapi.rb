class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-http-v0.6.0.tar.gz"
  sha256 "f34442a5a4531fd5e0694ed5c62ddf7e1795d940cabc7346bc7a8cac3af73923"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860764039a521160940b729c54e99f46c635123e00a959da5ad7adda1ff63562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f3df865db1db0b6c67f18a9c1d62a6e2cf6e6e45289af90cd6ef9949eb72548"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d5100d88ba4f4120703f8583779cbfbeef1ba6372741c337671c9ea770fbae"
    sha256 cellar: :any_skip_relocation, big_sur:        "9657fa78fc050f4e6171e64063b580d374048df1945e01e0cd1b83ab8f0c8a1b"
    sha256 cellar: :any_skip_relocation, catalina:       "f77443e8516f3c5258fde1907e52570cf66b9fa3a877615888da1f1343ec98e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecae7c8fa73bcf5952eca610e8b60622659af0c4416b9ce75b33d45f061c46a7"
  end

  depends_on "rust" => :build

  def install
    # skip default features like snmalloc which errs on ubuntu 16.04
    system "cargo", "install", "--no-default-features",
                               "--features", "rustls",
                               *std_cargo_args(path: "roapi-http")
  end

  test do
    # test that versioning works
    assert_equal "roapi-http #{version}", shell_output("#{bin}/roapi-http -V").strip

    # test CSV reading + JSON response
    port = free_port
    (testpath/"data.csv").write "name,age\nsam,27\n"
    expected_output = '[{"name":"sam"}]'

    begin
      pid = fork do
        exec bin/"roapi-http", "-a", "localhost:#{port}", "-t", "#{testpath}/data.csv"
      end
      query = "SELECT name from data"
      header = "ACCEPT: application/json"
      url = "localhost:#{port}/api/sql"
      assert_match expected_output, shell_output("curl -s -X POST -H '#{header}' -d '#{query}' #{url}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
