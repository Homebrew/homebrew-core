class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.12.6.tar.gz"
  sha256 "15b4f7c7b16b1fa87a487569d42e76355acbce9ecdaaa34bf1203326d77e7b57"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6116ecb02c112d2f990024d034ba242894e9e4a023f6756f883e0ec58b3408e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3bf66401f133a7d2e9234280571eed8cf06b9f1b98802762b5995b456414077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d1d6423d420c65fe3f2b414fdd0c33a67226d5afae78c5ddebf6e4dea35931"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2e0e0df5b406870033b3284ad136e6566c4f1fefb32c8d7c36f75c42f3e931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "528ea8f1d1cb5818ac4259bddd081f9e03069e78cb254f8f74c3de15f0720eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8b39ad8324ea2d41fa80ff81a6c623453ab504752e02c915eed48d11b212616"
  end

  depends_on "rust" => :build

  # Fix to error: hiding a lifetime that's elided elsewhere is confusing
  # Should remove on next release
  patch do
    url "https://github.com/roapi/roapi/commit/f01f6b4d9e08638052afbde907316052bb241856.patch?full_index=1"
    sha256 "ad02d21a2327d18b0d60b59a56c8d2019b76627be793ed3ab330be95a4e1b79b"
  end
  patch do
    url "https://github.com/roapi/roapi/commit/162dbfe5ad1b6815691b33fc9cc096e37773d767.patch?full_index=1"
    sha256 "00786352042683d2c7951d41a72fe69bd67f04bab1420016f758f0ddae8bb88b"
  end

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
