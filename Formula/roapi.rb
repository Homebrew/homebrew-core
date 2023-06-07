class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.9.0.tar.gz"
  sha256 "90dc3c036ba284504f0af023e343603b74a8f9222999fa6968fd2d7782fa6bac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e985295ec049440a4de8847b2572e6aca8be1e31603623b310a47ef333c9216f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e9f75ce10c6e60d8a6101eb1c40781b96a859a026656194c1ba3632f3ef6f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98dec57754abe011af47c52623981039c31c49e1d7275214ac9d79252a1d5642"
    sha256 cellar: :any_skip_relocation, ventura:        "6daf36288d0cc4d48084c819c772286f66152b358dfd6e84d45c675d5ebc380d"
    sha256 cellar: :any_skip_relocation, monterey:       "56019992e8e75b0493423015d4e86160ff8103c831bbddf43c860199142092e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d2f2d1db30113ff3c3b6bb5e9669c02889293e0e99a6d92a13674f521a73e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cec37d5bebb1ff28144fd339bd1120599c71d9628042500bbc83e038b5122fd"
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
