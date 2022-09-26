class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-http-v0.8.0.tar.gz"
  sha256 "f5c41052385d90df76df8cf7a4a6d69e4efa41acceb9fe2e010ffcd45e338ce1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1730bb3162014061f687094fd4d4d496a0107702c62b8ea23b84ac7c01e07438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bc33003ee596b62e1d15e6ed06ead02058c9d0d2559b34e4f31ea7b7a522d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b177df0f19ae1dbaf3049ade4009d6c2315a9251b937e96c03244e72d2518d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fb4b6d761a877cc9def732390c889bce307437f65d35b585c544ddec50793f1"
    sha256 cellar: :any_skip_relocation, catalina:       "b496e722f5814f9db4455d183bcb27b030f4508c631184a99b0552989b9749e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43cbe90644c1b82707e418fd5ac09cc907bd039ffc4a8dbdc0f94ac1a8758374"
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
