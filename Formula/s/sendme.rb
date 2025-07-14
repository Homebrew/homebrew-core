class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "d41bd166e08b611d993e4bdf01c66610406fe93338783fe9a310eaf726fc337f"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e9e14ec2f39f461b899a8d6c0dedfaee493b49674c40ef11d3a1f5f42f58de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9670e36e17de672428e0894f4545f1974db38c17615e533c3e508d56f6f4d43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70fbf950de08c9d17d5499da8fafb68208523331bc988b84112f2fa3ce8309ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7bd3d3efda5aae5d52b9985325dd8892611349f9258a773e058bd661b75e58f"
    sha256 cellar: :any_skip_relocation, ventura:       "036983cc3a388d0aed8096a078b42f39f98e3199309fac245057e554dfbc1405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb83096740b4615fb2a41d62536a6625d342db45bf85e1df35a3ae7a8de320ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26cea22df1f133fda1526b2807ba8c08df227f85de2f5597d237977b176fc7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendme --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"sendme", "send", bin/"sendme", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
