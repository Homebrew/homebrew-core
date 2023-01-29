class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.9.0.tar.gz"
  sha256 "90dc3c036ba284504f0af023e343603b74a8f9222999fa6968fd2d7782fa6bac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546f682eb5b26183ff56189daead51a6907e05287d4df6b373fd11647ff9f38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4413ce68f5ae5f2f6a1e08b0c097933b06139881c7528bdd0107567e3ec82fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e3f2e3b036b69a468dfa436780278673bbeadfb6ea5cee47873282c5a7588ec"
    sha256 cellar: :any_skip_relocation, ventura:        "a1e0d7e3f4d15a735ec2369392d0d04dc614599e5fc567dd50dccc6183f05e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "71d3e5f10ff499faa3cf552ddb1dc5720fcb405b57e041801008c4c8f27f8a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c79e3ae0493c0e26eb3d8b5de1724e2792b5b805ed7cf835e461815d27667658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b1d8658e39370769121a4733a713fcc0361ff56970034f505b0772bec83e2b"
  end

  depends_on "rust" => :build

  def install
    # skip default features like snmalloc which errs on ubuntu 16.04
    system "cargo", "install", "--no-default-features",
                               "--features", "rustls",
                               *std_cargo_args(path: "roapi")
  end

  test do
    # test that versioning works
    assert_equal "roapi #{version}", shell_output("#{bin}/roapi -V").strip

    # test CSV reading + JSON response
    port = free_port
    (testpath/"data.csv").write "name,age\nsam,27\n"
    expected_output = '[{"name":"sam"}]'

    begin
      pid = fork do
        exec bin/"roapi", "-a", "localhost:#{port}", "-t", "#{testpath}/data.csv"
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
