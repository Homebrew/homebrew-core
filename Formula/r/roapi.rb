class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.11.3.tar.gz"
  sha256 "917fa5fb26773ac4653fa89b62f9d9f98272071b33660145c2dfd48c17a5368a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0cbd87075129962e9b10df6a0641ec36a80ee2060b753fec9bde1c948185738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd256001e217e06f76cb6c27b29815133736c6e89b7737fed006d83ac7aedc2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bbbfd5883ef4f04e723f435a57a0c9a40cafeacb3ff218b24f019fd1c08391f"
    sha256 cellar: :any_skip_relocation, sonoma:         "57a205243eb20c75ed03f6f89ccdcabf5c155edd849c0362fb12aff8ffdfea19"
    sha256 cellar: :any_skip_relocation, ventura:        "d4fb5675d826ffcdd0ea50046dc62253a8ac88234c7386d0dca57ce260e493c1"
    sha256 cellar: :any_skip_relocation, monterey:       "a29debab95007a26e14c4a5d4dcd06aad11199e8d107b10cf4e94a5b7f4e6230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf631219be71602b9feab8933f3af2f1a2878ba0a93defa8ba3035e7a91c371"
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
