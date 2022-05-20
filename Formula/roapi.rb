class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-http-v0.6.0.tar.gz"
  sha256 "f34442a5a4531fd5e0694ed5c62ddf7e1795d940cabc7346bc7a8cac3af73923"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6989cb10b8b9a31a9d96c9005fc906eb554edb6fd2bba0a47269368819f66cb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf60b80c586219ca68ca7064486712f419b4f118334e4f1c87e0805aaa35e574"
    sha256 cellar: :any_skip_relocation, monterey:       "a37e8aa6a3f5ecfb53e0e1cf7f43b59a5c66f6189e4f43d8e054d6108c82b9cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "661e817f76b84b0b22b48f5327afef4ffbc771a7a219bff5f9704a1d8a725e35"
    sha256 cellar: :any_skip_relocation, catalina:       "65c5e29790633d44a203857289a82af0229bdddf04698d477be44b680d3a8b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a20faa69ca6e0bf11b967ad757c8118b1311e21043681e494efd9d8b9b0770"
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
