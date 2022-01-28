class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-http-v0.5.3.tar.gz"
  sha256 "96b101d6cb9ed638985fc3989fdaf45c47847085779e0fc51f7baa3375518b89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97bf719e3683e4ad0718b9529e75eb3fe7763e5867b8f2bb05edbe70bf9bcac1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd9431f46f5f498a3c95f3b039802b9d5d8be10b1482262849ae8852944729f"
    sha256 cellar: :any_skip_relocation, monterey:       "65ad1d0d32ed504eac22cdf76a546aff2b323dede67662207404ac31928bf451"
    sha256 cellar: :any_skip_relocation, big_sur:        "36f571b9c87f7a10b56654abd703911203c116412a737b2aae72e4b6234c011a"
    sha256 cellar: :any_skip_relocation, catalina:       "0d52cd6a52e577b2d910fb2b58a935aeb407f8c4069f2d34c0744a8a384f1ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff8c1e15afc4a592c757f539080960f09e865c093aa02c65c52c56bbb21869e"
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
