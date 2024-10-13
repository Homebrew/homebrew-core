class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.12.0.tar.gz"
  sha256 "09f9099f04f92e92598b16fe00402911fff6b77cc4d32268ad1fb4a0b5894c8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "12756f6b86bd189b2bcb444d200049b09264d096b5cf7fdbbe1536ea7e1f7ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a16d694e11386fc0c3f51e85c09fef77700144bba892fb70fdc1eaecb746ce66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba231911f565dca0268339c8c426c45128b1bb088eb480d5b16b12e71a8d0cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35f68070f49a803a0f529e558905d1a125dd01dfe01d358ffd9e765d2200f71"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff6829464f03a64581c991b3acca0253528c0c19a8126ccfbe1fc1558818ab24"
    sha256 cellar: :any_skip_relocation, ventura:        "aa2f896df54d34d3ef8d9ea636a1b1ae9b3f5d8ca8198ca9cb75c2c0fe5fa354"
    sha256 cellar: :any_skip_relocation, monterey:       "21047cca3b02f907b1b9738d6a1fad4c8f90dc667eea82a58c6274f5c57660c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3648ef60df4409b75d36fa6d7e87ca7c4849e5b054339e02d984e17bfe0cf390"
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
