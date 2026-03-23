class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.12.7.tar.gz"
  sha256 "97d30e5f8d8ea9292a05ab67925ca71246c96cdc82d690a95242b186d656c714"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "206a038df2a8bcfc3b22cae42d0ba36a22c8d75bc5347eef165abca1fd0fd291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4392cba3e8df84b89d7a1da7a6bf3753172a98058f0dcb109e4c050a9ac2ef82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a90e2178cf2ef6830efa3d31f53311129508b67b1be6152d2f26b8555946047d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0cdbe9d524400a20e42412b7335fba2d39c091633b81e268ec8a7370f9d879e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43120591307e4b3423f72675135854c05a634ce79cb1a28812bb345bbcb8f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e85bf2d4fd6880821e4300f86781f5ec072c5c5be68301c76c04452e0090138"
  end

  depends_on "rust" => :build

  def install
    # skip default features like snmalloc which errs on ubuntu 16.04
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "roapi", features: "rustls")
  end

  test do
    # test that versioning works
    assert_equal "roapi #{version}", shell_output("#{bin}/roapi -V").strip

    # test CSV reading + JSON response
    port = free_port
    (testpath/"data.csv").write "name,age\nsam,27\n"
    expected_output = '[{"name":"sam"}]'

    pid = spawn bin/"roapi", "-a", "localhost:#{port}", "-t", testpath/"data.csv"
    begin
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
