class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bc74f8b42c24025af69376f1bb3a3927d2f1bea656205e37a07f5f4576e8fb00"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d6b2715e844dd65dffd703ef7c542d093519b7b86553e6d00fd0055c106b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea62db782b8cf5a614c558f47ca3bc7da63633ea1c3543f447e870d7e0672564"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "048ed3a2d53dabd60072ac3e1757c0719b6367247dc725289c53df7971fbebb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "50bc79d1da15b1dc30131146ca4ec326ebf168538cbb7ea03f841754fe8a99a0"
    sha256 cellar: :any_skip_relocation, ventura:       "d9af779c75bda5773983e8e20e6389e639e0fe403aa5e31abdbe317095a9b36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f8db4f1ca340aea473a927442ce6575a9133596b803fe974ad94279694a370"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin/"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}/viddy --version")
  end
end
