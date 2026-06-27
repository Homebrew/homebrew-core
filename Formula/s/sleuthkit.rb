class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.15.0/sleuthkit-4.15.0.tar.gz"
  sha256 "3a8c1e7d18a9b81f3e5e8aa78313974aceaafc6e051d636bc92cd7168286eca9"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/sleuthkit[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8233c5659ba82a3205be66daffa367de9c19e3bd571fa7832f2834212410e6f8"
    sha256 cellar: :any,                 arm64_sequoia: "f9e7ee4dd3deaf1501c319c1fe5ecf51c00304452f04869ed326ed7f80c23093"
    sha256 cellar: :any,                 arm64_sonoma:  "f13a74ab449fcd144c40c93afcb71596f9ba54eee8cc6e2dbd1a7d0ddd2a3828"
    sha256 cellar: :any,                 sonoma:        "e079c6a173f523658c6d26f536899c198178c953c76ccf5df0b41d646ccde891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd317ae9a6cc96e26521c5a80e0c2cf83e6e692911f1d5ec97ae87b294bec0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ffae9958cc8fcdc806aa0676b483b7a374024e612221b291f20abbe001f0b2"
  end

  depends_on "ant" => :build

  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ffind", because: "both install a `ffind` executable"

  def install
    ENV["JAVA_HOME"] = java_home = Language::Java.java_home
    # https://github.com/sleuthkit/sleuthkit/blob/develop/docs/README_Java.md#macos
    ENV["JNI_CPPFLAGS"] = "-I#{java_home}/include -I#{java_home}/include/darwin" if OS.mac?
    # https://github.com/sleuthkit/sleuthkit/issues/3216
    ENV.deparallelize

    system "./configure", "--disable-silent-rules", "--enable-java", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tsk_loaddb", "-V"
  end
end
