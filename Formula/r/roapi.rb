class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.12.6.tar.gz"
  sha256 "15b4f7c7b16b1fa87a487569d42e76355acbce9ecdaaa34bf1203326d77e7b57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3956e422ccb0f38acf4b6f7bd1559a45bfcac486b0ed8d1847c17695a57d6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5fc8e2447e1939d61cc473a0b1ce1c30e885d01c147333d27bffd76ec0d2d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67488c995ae301353530eac0c1800c3901fced543977196072ec8c1956fdfb83"
    sha256 cellar: :any_skip_relocation, sonoma:        "5786fb90f1723236f17c85b864a5fdb7a4662972a1f35dea98576aca694b8c80"
    sha256 cellar: :any_skip_relocation, ventura:       "416545a6b5320bf276662b8e04211fc233986881aa3d2474de60e1f59f5137d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d5ce3edee23f8feed72bab62416f57655dba00e81919d0428fde847186a2693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eedb5a6729589943b959219b9a4d37bbea13434170f21f5c1532873f3a1b1372"
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
