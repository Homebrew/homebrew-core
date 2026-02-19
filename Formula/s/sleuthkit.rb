class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.14.0/sleuthkit-4.14.0.tar.gz"
  sha256 "fb6ea1801bcfc4c7d3a283d7592c6bd65add655411749513b5c429b86541e9a9"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/sleuthkit[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b509c1e4664588e04309784d104c6b151ade8962c2596d1a6887254bd2c25c0c"
    sha256 cellar: :any,                 arm64_sequoia: "eb0cfa9f7d27ce5425e828e33b98370490358cc5d4891ac869e28418ece88505"
    sha256 cellar: :any,                 arm64_sonoma:  "cc8351ad280fd8f5b6fb33b25d68b1215bfe0cd397d61b850e2686e48e860001"
    sha256 cellar: :any,                 sonoma:        "d877f5a2a7235ec0c29907a204133365be7e1a7b94bb95bd47bae415136801f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d88741845bb3810889a280fbff58850b928532b501ecb15b35a016cafb3b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4694ab7a319e1555839c78f109726ce9c6c2b3b47b6c51f325b7da3c09eed8b2"
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
