class SpawnFcgi < Formula
  desc "Spawn FastCGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.6.tar.gz"
  sha256 "4ffe2e9763cf71ca52c3d642a7bfe20d6be292ba0f2ec07a5900c3110d0e5a85"
  license "BSD-3-Clause"
  head "https://git.lighttpd.net/lighttpd/spawn-fcgi.git", branch: "master"

  livecheck do
    url :head
    regex(/^(?:spawn-fcgi-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5bbb07b33b933e1e9ebd6f2599c7aa1be3baae04fd639e8ec9cc52ba266bd20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b540af48ba02659346767032b75465695a1fb5b3dafcab07cd36d030853dd2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e8c306a84a1948d46f1b1ebbd1b687c7af8ca096858d1094669b3458ecb916f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0049c20c4199fa06b3a1c4e6afcdf2a304dca80ecaf1cfbaed01a0c44caaf607"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17dc03209b37cf23672a7da324f71b08834bd6c3fe93cc208f6479493c3da0a"
    sha256 cellar: :any_skip_relocation, ventura:       "90b6d07b1720306dcbc1239fcdf9f6f1c84728ae5f6378fd4bf9ca8bb8d00c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e628bf7b388f27fe1cf51a0417c5bbf53f2ea29e1d9bb164eeecb649bbfe6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d25240823bc460d243bb2c92c1773f9cc650d65361ad4ceaf189390a644227"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"spawn-fcgi", "--version"
  end
end
