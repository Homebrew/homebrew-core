class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.13.0/sleuthkit-4.13.0.tar.gz"
  sha256 "f1490de8487df8708a4287c0d03bf0cb2153a799db98c584ab60def5c55c68f2"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/sleuthkit[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad83ccab278a2bde2b9de481aa4d7f52b95eba0d7887107534e0faf3276db984"
    sha256 cellar: :any,                 arm64_sonoma:  "ef3811813c2bf8cab4058c530e89e1d41a8f282d50f9ef9a05b227545d6860fa"
    sha256 cellar: :any,                 arm64_ventura: "e1719ef61afa765f11603529ded27e3c14cd5094f9944a536881e1fcc071229b"
    sha256 cellar: :any,                 sonoma:        "59b9624df6e1a9fa7a2f5b0b48fbd193f07ad7ad535f13baf7a6fe52451897a3"
    sha256 cellar: :any,                 ventura:       "586885369c5a5b13e4e431a8c033f51175d21ae472b2af7bfe39b5bcdd4a44c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b25b4a55a410e31686316c642da1b0e1c00aba49a47a236b9b906d138bdf164d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2863754f9fa716414d744f145f5e8d22ce1f3d5638557313138d8aa6c08a170f"
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
