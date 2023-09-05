class Xdpyinfo < Formula
  desc "X.Org: Utility for displaying information about an X server"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/app/xdpyinfo-1.3.4.tar.xz"
  sha256 "a8ada581dbd7266440d7c3794fa89edf6b99b8857fc2e8c31042684f3af4822b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4f808deface10045a57d8b83baee19ec7737b239af0e3638f5bb4fe879197f2"
    sha256 cellar: :any,                 arm64_monterey: "ca1b56d68034d1414cec3f638b17a81fcaa5434505ac0c1beb38003599e2a78a"
    sha256 cellar: :any,                 arm64_big_sur:  "e2be6a8a5886c59f1e74311daf91b46a93f82a548c6db53e8bb9fd38562d9dd4"
    sha256 cellar: :any,                 ventura:        "9df6c27f362d5ad88cb70ec4f81c77e63eda93f8be5f47e4882b15275c469be2"
    sha256 cellar: :any,                 monterey:       "657234728dc1b95dd0a01297bb63c4c7a9dc8a0c9884a9ec4fe26f2f5e697571"
    sha256 cellar: :any,                 big_sur:        "715024678add793ed4a3649bec8b5d57fc8f0f17bbd1bff780662160068b6719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f37e0dbf3c6c0741151f53befb6a5bc82b2fab008b3d28ce4cedf63e6a8bbbf"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxtst"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # xdpyinfo:  unable to open display "".
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match("xdpyinfo #{version}", shell_output("DISPLAY= xdpyinfo -version 2>&1"))
  end
end
