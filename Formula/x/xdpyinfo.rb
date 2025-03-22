class Xdpyinfo < Formula
  desc "X.Org: Utility for displaying information about an X server"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/app/xdpyinfo-1.3.4.tar.xz"
  sha256 "a8ada581dbd7266440d7c3794fa89edf6b99b8857fc2e8c31042684f3af4822b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6dbc9389db6707290660a6d54963d4a047e6243e94a24b61b265931bd6bfde8f"
    sha256 cellar: :any,                 arm64_sonoma:   "baf82ff9c8adc230c5a18e342b1fa449560d2f52940f568756a8fdc41fca3f15"
    sha256 cellar: :any,                 arm64_ventura:  "e4f808deface10045a57d8b83baee19ec7737b239af0e3638f5bb4fe879197f2"
    sha256 cellar: :any,                 arm64_monterey: "ca1b56d68034d1414cec3f638b17a81fcaa5434505ac0c1beb38003599e2a78a"
    sha256 cellar: :any,                 arm64_big_sur:  "e2be6a8a5886c59f1e74311daf91b46a93f82a548c6db53e8bb9fd38562d9dd4"
    sha256 cellar: :any,                 sonoma:         "2f7afde3293852e250a3b9e44b942f1668b4173ee62f1da53733dfb0b43663f9"
    sha256 cellar: :any,                 ventura:        "9df6c27f362d5ad88cb70ec4f81c77e63eda93f8be5f47e4882b15275c469be2"
    sha256 cellar: :any,                 monterey:       "657234728dc1b95dd0a01297bb63c4c7a9dc8a0c9884a9ec4fe26f2f5e697571"
    sha256 cellar: :any,                 big_sur:        "715024678add793ed4a3649bec8b5d57fc8f0f17bbd1bff780662160068b6719"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eb4084730b91a26fc9ede2cf183a56eb74792d4b27ec1266d1618cbe1fe3a520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f37e0dbf3c6c0741151f53befb6a5bc82b2fab008b3d28ce4cedf63e6a8bbbf"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxtst"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # xdpyinfo:  unable to open display "".
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match("xdpyinfo #{version}", shell_output("DISPLAY= xdpyinfo -version"))
  end
end
