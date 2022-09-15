class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.05.tar.gz"
  sha256 "2ee20333d306037cf44f4e8d038bc6253106dcb54f37ee548e9adfd94a6a391c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f8eec3045b0e38043c077e0324ab71d8113750467157b0119f0e8897d83d0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08188fcd33a552e93a84e77704662a49219bd6e1be5c01eaafc17338e2f8fe6a"
    sha256 cellar: :any_skip_relocation, monterey:       "0f90860dfc908e3248b6c9a03f4671f2d8c6804d23bb7ba32d7cfa81ca6b6754"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7932ea2ca160594ac4e33eb8e9c02f0e3b34378417b4b0c14ab7f8d9ee65cf6"
    sha256 cellar: :any_skip_relocation, catalina:       "8d84ee0be6c55fff30e0dda8113978f9dc26ebd8d75944473b5f6b31ca2374dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dd4f375701811c5e8972ab6bc6d53a8e4e5ebe9aff25564f31de5e2046f9a50"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
