class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.10.0.tar.gz"
  sha256 "85d194b78dfef8aaab5da0c609d8c6d126ee0d474e6b1455b6ca3c7f1b8afd06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da0ff1811b9e4d919e86f901e1d4017a80e69e6f539bfd53d5f44e8cc72aa117"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92b3d686644d95288450228953cb884a81abb76b36ca0884f5b08adad9ef4d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e70fa2082fd8b32fd9dfbac610fd2f31a57bca475ca6c1daaa9013b10939fd7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "207a3d71484b4526a106991fba4dbc66a2dacb46523b24de35fb821f51c186e6"
    sha256 cellar: :any_skip_relocation, ventura:        "4a9ca50752ccea857755dc4aa12a956d4ef62ea1a9e9ad66a0e2b720ead32241"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd306cb30e00d2514de46a34542b22dd050b09ec37c2db3f672061bc9094fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ba8869362eb39131a1e983affe78d6791707fec63330d4412d126f56d4d5d0c"
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
