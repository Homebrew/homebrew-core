class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.12.3.tar.gz"
  sha256 "3ffb4c3aaa261dd18d8d4def4a2330d498181b4e1ec7f3dd7f1844af85f6d90e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2f2fcd242495a8ee0a8cca2c3f0149998e6e2698399b502cd35ec76e15f300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73591b92cc358261463e3ee4bc8120989324ffd6620d40b22bc57b21e7af39b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c3a85d935b249fe3afd3c41ea6595707325edfe9d0ebe808fe7d5037f629164"
    sha256 cellar: :any_skip_relocation, sonoma:        "235343dfea88062d54a19833f0e0484b7ee330a9e256476be33f55fbfb63aef2"
    sha256 cellar: :any_skip_relocation, ventura:       "ed1f8f47e61389ae026c515d8bcd954aff7b2178cf5a061135966958a035eb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fedd7c0ce890700874a490d1fbbdf0124ca1dd7d0cdce09fdddde74c805b27eb"
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
