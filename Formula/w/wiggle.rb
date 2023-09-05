class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "https://github.com/neilbrown/wiggle"
  url "https://github.com/neilbrown/wiggle/archive/refs/tags/v1.3.tar.gz"
  sha256 "ff92cf0133c1f4dce33563e263cb30e7ddb6f4abdf86d427b1ec1490bec25afa"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af2e82816a399f7da15006e81343855ef0c205ddc22bbc2a90047d0f99ac4339"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2340430acf70ad6cff33fb034eda572c80f359b3847b90ebcce1c732cc2bb792"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f585911f982b406255e79f0c3b6a4a71b7e438b0d102f1d9c39d1fdb806fe40e"
    sha256 cellar: :any_skip_relocation, ventura:        "0b66da10e6bd799da3b4a24c0571fb62dc3b22d2f9c2a748c9d61f00eb82a087"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef8230cd01f245db7718475da9c898919bc52b9729b2a603e797dce13d796fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "233a538ebdde21f7038aafd73fb4a20afb0dbb6715f54f4fc305ad7ca4966672"
    sha256 cellar: :any_skip_relocation, catalina:       "e50353191b0368db9dd898d730b74ea3612c1cff728717fc8b5904a6d44e2015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9181d60a846d40b7850bb1647b1dcfba43a56f46d26bda4965df7e6f9857900"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end

  test do
    system "#{bin}/wiggle", "--version"
  end
end
