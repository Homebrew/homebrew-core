class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.13.0.tar.gz"
  sha256 "f1941e528efac4c610cc042bff7f03a613d7d7b59e2a7f8c10cea8c478d915ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac8101f79606c4ae4f5349cdc1ec7f704918ed4273007bf9c1219d2e142286b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80cf32ea0736c933171f0f7df7b5f20d7ec73352e096a9a3e2a6c90aa2fbf2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3491c3a39585e6d943f8d4370c83078339f1b8b93e4e815bbd454c340f87dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "42bf88fd3ced3d5dd910013dda2914d236b559f707f90665cd452a8f5b448bc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a0b027bc370aa4e0e5e798be33fd634cb8a9f497f2116c6ed3a9c2043b38fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b853f090ebe4651667143325ffc6a7462764a4185713c67d3ce2f7448ce7e91e"
  end

  depends_on "rust" => :build

  # Patch to fix build error, remove in next release
  patch do
    url "https://github.com/roapi/roapi/commit/c53bfa489011038cb934735451d88dcd9f39dbe2.patch?full_index=1"
    sha256 "0bdb9950c1f9e69670283f4fb491f2d71ce0f18248345c38869b4a6615ac823e"
  end

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
