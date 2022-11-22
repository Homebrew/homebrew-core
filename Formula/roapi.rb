class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-http-v0.8.0.tar.gz"
  sha256 "f5c41052385d90df76df8cf7a4a6d69e4efa41acceb9fe2e010ffcd45e338ce1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0df94d69cd5232f90543f5e6d5dfc2eea907bb6b542899b726da09d0fa8bdb01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c195d5001a94a5eeb74c05f283e3ad6e1631838210d783a0d19a09261b2a13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7180ead91ca0af075d324a6dfa12ee64abd22baba95c25aed3845991e731181"
    sha256 cellar: :any_skip_relocation, ventura:        "8ea604ee498260886881a873c8da9f3bf7ecc7594d5fe0b5a56341ca9baf538a"
    sha256 cellar: :any_skip_relocation, monterey:       "3810624addf6dc222b324c46bb6862799a37fadbee8e189cf02b6b60b520eccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4985092d28eed9ff252d5f2f4aaec367c2cb91bcff602e9bf727d83be0dbd2f"
    sha256 cellar: :any_skip_relocation, catalina:       "7c975bc1f1ebcdc374965a20794fc57f916c97721b4ad0fe12cfae72c3d90b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd15a2265aa4d0df9e3386c3f6a22a08962cbe02d99285f48fbcd657441b9347"
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
