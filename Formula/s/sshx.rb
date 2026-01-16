class Sshx < Formula
  desc "Fast, collaborative live terminal sharing over the web"
  homepage "https://sshx.io"
  url "https://github.com/ekzhang/sshx/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ab6de41546b849726faa3b964466c1f8bb558bd27ee2452a9758405ff013108f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9d50ad7a068ac3520358e2219172c137bddd2b1c6b415d7dff20c21a10896d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd4783508a0db2af33c4d72a8b31d340f822c9d2624061301545f312e05075d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3598a6c4352b930499296f07e1bae871eed59cd974a24e31301706c2f6c70ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b6e4d71103322becc0361d2940862a5f7289d8677076aa230ceb77c12c9fd3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "acb77c27444b26c774e81104783ae34f10773a454f43116ae97d368ddf26fc5a"
    sha256 cellar: :any_skip_relocation, ventura:       "a42df234bc853d19f5c67d6b980fa9c6947063fa37e64471d5be0f194444ab21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9055d91e23321fa85ab586a83204ad383caaeec4b1af12bf13bd5b901fc03461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d9f3653dbfd7c5b4699821fa328d4681686bea5a21a6dea4f832f4efa45333"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sshx")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sshx --version")

    begin
      process = IO.popen "#{bin}/sshx --quiet"
      sleep 1
      Process.kill "TERM", process.pid
      assert_match "https://sshx.io/s/", process.read
    ensure
      Process.wait process.pid
    end
  end
end
