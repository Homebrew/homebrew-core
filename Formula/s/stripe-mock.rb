class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://github.com/stripe/stripe-mock/archive/refs/tags/v0.193.0.tar.gz"
  sha256 "a8cff7d687efab9eb8a5bfc4fa72f545502f8570dcde9134f77da8e66b315da5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33843a89673fa80d1081eeb8d0ec337bbbbaa738ca25a7d0c1cf3d8e30fcf16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33843a89673fa80d1081eeb8d0ec337bbbbaa738ca25a7d0c1cf3d8e30fcf16b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33843a89673fa80d1081eeb8d0ec337bbbbaa738ca25a7d0c1cf3d8e30fcf16b"
    sha256 cellar: :any_skip_relocation, sonoma:        "44b311dc629776ddced7878c31eaee622185ef70f57d70832b715b8a354ff7d3"
    sha256 cellar: :any_skip_relocation, ventura:       "44b311dc629776ddced7878c31eaee622185ef70f57d70832b715b8a354ff7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5914ad3f4b6db69806b94bad17d9568a3fff03986c1a06c07cb6aa1ccd3a9fac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  service do
    run [opt_bin/"stripe-mock", "-http-port", "12111", "-https-port", "12112"]
    keep_alive successful_exit: false
    working_dir var
    log_path var/"log/stripe-mock.log"
    error_log_path var/"log/stripe-mock.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe-mock version")

    sock = testpath/"stripe-mock.sock"
    pid = spawn(bin/"stripe-mock", "-http-unix", sock)

    sleep 5
    assert_path_exists sock
    assert_predicate sock, :socket?
  ensure
    Process.kill "TERM", pid
  end
end
