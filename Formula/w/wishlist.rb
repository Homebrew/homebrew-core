class Wishlist < Formula
  desc "Single entrypoint for multiple SSH endpoints"
  homepage "https://github.com/charmbracelet/wishlist"
  url "https://github.com/charmbracelet/wishlist/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "ba1a9bbd1925e2793d5eb97e38351faf5f9efdc89921af1f1322d9b88b94bdba"
  license "MIT"
  head "https://github.com/charmbracelet/wishlist.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd6459f6fa4774495cadc75ab3fb08547c72126193931309609eb2e9eb872061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd6459f6fa4774495cadc75ab3fb08547c72126193931309609eb2e9eb872061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd6459f6fa4774495cadc75ab3fb08547c72126193931309609eb2e9eb872061"
    sha256 cellar: :any_skip_relocation, sonoma:        "730832deb846f179d320f14d2e1c52c19103d4c8a3cd3285b914a87036bcd021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "190c7e8db9f1d08cf2440ceab664fbcaeec77bba32e425ca8fdcadb1f17c67e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273cf16e89e4b739b246f4c949c4ee4c626256900cfb3ea83ecb68af13dec649"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/wishlist"
    generate_completions_from_executable(bin/"wishlist", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wishlist --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"wishlist", "serve", [:out, :err] => output_log.to_s
    sleep 1
    begin
      assert_match "Starting SSH server", output_log.read
      assert_path_exists testpath/".wishlist"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
