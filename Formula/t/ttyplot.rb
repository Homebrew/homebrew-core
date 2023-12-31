class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.6.1.tar.gz"
  sha256 "a6d0cfb2ec37ea6b4aaf978a8190ca0f42eacd4841f62da4ea2d93ecefc4dd28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d4915111b615634ac2b86fef3e0b5efcb5700e73e0a8a306e77e36214c6a132"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f30051b8bff85d9034ceb6f719085f341c92d9634632af1f0d350152d22f7ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa39b2d577e9e9452e9063d59e3b6c50bfc21c081365e393af28ce0596085f5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef03bce445e8d4c3a28ab91c89706eefda9131b762f061d1fb233e0d0922fd1e"
    sha256 cellar: :any_skip_relocation, ventura:        "ceba75d2a16ae12b425040458fd2f87aa56053039b7eb6cfe6878ed6a47b0abc"
    sha256 cellar: :any_skip_relocation, monterey:       "a42c2eb991d53ee2c6b5e6660ca1da7d18f899b4f6532462f6519ab9ba673ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4aee3945009a36795e973e2885fe135627514c8711e3147acb131cfa2832ff6"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}/ttyplot -h")
  end
end
