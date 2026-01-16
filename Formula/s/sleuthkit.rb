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
    sha256 cellar: :any,                 arm64_tahoe:   "2f05503ba819fabf434097defa4e8968471199abd9fc9ce1ade416c8f548c0ba"
    sha256 cellar: :any,                 arm64_sequoia: "4618433aefde7d203834d43f15b6a100f233c3e4173ef2fd1fe708d0fed22988"
    sha256 cellar: :any,                 arm64_sonoma:  "73615ba817ae871688f19a26e23d1751019862f4df4543af2f7d5b9006907c1b"
    sha256 cellar: :any,                 arm64_ventura: "ccb252574fbfa02e92dd5c708392d05ee5c4603e40162e03ea2129acb1ef4a86"
    sha256 cellar: :any,                 sonoma:        "bca1bf151256fcddcd5a8c0597e42bd2df0bca96f6a440c6dbe1f70de9326a52"
    sha256 cellar: :any,                 ventura:       "3e478aa0baea538d7343c5786f6b15358a114e3ca81a3d36d3ed44e7d63525d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e73d02460dc9c1eafee2ad805c562db85fcd4519c04d1c5845d50eb36a9ac288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24edf33851639af78901322c231f25100791200e4f8ad644078bc54cb3f425a"
  end

  depends_on "ant" => :build

  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "zlib"

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
