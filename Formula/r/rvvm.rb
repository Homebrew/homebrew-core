class Rvvm < Formula
  desc "RISC-V Virtual Machine"
  homepage "https://github.com/LekKit/RVVM"
  url "https://github.com/LekKit/RVVM/archive/refs/tags/v0.6.tar.gz"
  sha256 "97e98c95d8785438758b81fb5c695b8eafb564502c6af7f52555b056e3bb7d7a"
  license "GPL-3.0-or-later"
  head "https://github.com/LekKit/RVVM.git", branch: "staging"

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "sdl2"
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  def install
    system "make"
    bin.install Dir["release.*/rvvm_*"].first => "rvvm"
  end

  test do
    version_tag = /v#{version}-\w+/
    assert_match %r{https://github.com/LekKit/RVVM \(#{version_tag}\)}, shell_output("#{bin}/rvvm -h")
  end
end
