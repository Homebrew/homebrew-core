class Roapi < Formula
  desc "Full-fledged APIs for static datasets without writing a single line of code"
  homepage "https://roapi.github.io/docs"
  url "https://github.com/roapi/roapi/archive/refs/tags/roapi-v0.12.4.tar.gz"
  sha256 "93eaccd70b7b21d0d8f349d6ad594761b8c4ecba884c7106cfefa37d86e3649c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b120ba55e3cae8c3b3979b6a4d899dc07fe831cbd1d81ea5bcd06f455e14e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eaf36297f5273f3465dd39b7441e2d4b17048116d2034e2644d642c06c70da3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f27bf73c7209c9f00134bbf49a26a20fef0ae6a2e4c2902519117e6c15b9ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4f39cfc03ef9f4bfe2bd2c3ab2669039927f3febd15ad78bb9c5fd782cd978b"
    sha256 cellar: :any_skip_relocation, ventura:       "a09c14307b47d74173190e59281ec75b837c7331a7682e9990ad0f5398930f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9471f171c21d2db112488f7cd9656ab2ca1bcd6bb31c6c878cd18de3e8513b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c065cae70543fd020625fda6651e1a2dc3ab1e622db72ebf978d23b986fb57"
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
