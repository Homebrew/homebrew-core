class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.11.1.tar.gz"
  sha256 "0bc41ff939596b10a85cf1c81364d13d8c26ee32b5718c87bc39d9907d5be037"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d68a9355594e05b2129fa6fe02858109e5f669e78ebba8a579cf4c7bc1e04485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6dddf977f491d0e810ae720b4752e52ca9db3d92ec4ebea48f7f6ed661af5ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb229f0a93d5b83c641dd3648372ac98685853fa3ed3f5422b726695e68f0f31"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd09a90566de516a51808455373a270c8546ee137565fb3b45e9292e519bf3a4"
    sha256 cellar: :any_skip_relocation, ventura:        "3872b649489c184881e9d7ebaf3a8b4f13ab7e31c567f5f4f7a13712098ccbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "aac1d761a9091f6e70f1685d53b267c53e1fb3ff3dfbc9efa80cc5f34a883b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c6fcadaa9b92b1f63049fd65f127e6fc10f108578c5b9afb8bf0179ddbc2f6"
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
