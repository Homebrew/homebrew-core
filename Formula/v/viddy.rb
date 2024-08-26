class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "8489423be455240bffc4c61e671c7b600c15ee099b69ab99ff1e2100bf9a650b"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc34df54be2d113b83dbe49094c9a0322b3407e79ea2e447576a67f538192673"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3325c832b2df8e877e289013419d6216d5b3cc24968245dcd9a51738ccd30c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6b89fffd891ad85cca58e1d6e5cd09582ac0e6c3cc34781c95755c430cdc3b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "53582d8a7949c06fd6a20700519ae5968aa3bd9c0cbfbf1d0da82ba188850e91"
    sha256 cellar: :any_skip_relocation, ventura:        "7693ce668309eeb7540d735cd6766bcd3198572c7b1d57ec984cc0358ec4e84f"
    sha256 cellar: :any_skip_relocation, monterey:       "0f15f37fc256e3508c76c068f9eb1aa3e91404cb4ce8a1a935f87adcb62cd7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bcd3211797829d80e6eb4c5aead2955c1c3c8007ae36f39f950a5699b69d1f8"
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
