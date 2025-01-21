class Sshx < Formula
  desc "Fast, collaborative live terminal sharing over the web"
  homepage "https://sshx.io"
  url "https://github.com/ekzhang/sshx/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3bc2abc59be26c9eefaf7fc999aa4a3723d2916414c319fd06555415278acb64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b84aa6e2ad4daa270b250eb0cd6e150414e175d8703a1d9dea0a07d93f025880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15863a29663b38898f9ffe09bf78000ace55838767097d606b810927357a8081"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0516ecb4d0f5521d6668f9bb189e4c77ed216a0e3feaafe02daeaa51494671ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0fc18f4c9e7b205c7cddfb4b7caa2077b2e231fc178fd308d01b85ae5566771"
    sha256 cellar: :any_skip_relocation, ventura:       "26101a064282be47211f8c5006e95802295deefd9a23ff030a811842a481e7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afe4a7685bef08efbbd171c50b1e04cb9fde96d8089de191b48251b66488562"
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
