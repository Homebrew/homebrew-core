class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/4.0.1.tar.gz"
  sha256 "846cdd078209ee15189420c1ec47e6ffcf97fc5b196cd78b9952dc5de6c3e50e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abef4eb1ecee27916d91f329d384a3c1a17ca5125153e8fd3ddb254d107d7593"
    sha256 cellar: :any,                 arm64_sequoia: "b571e14d2e29ff17a03e8473e35d9edca038c709e0d79205749330b1aa1e7a6f"
    sha256 cellar: :any,                 arm64_sonoma:  "562c8cb50dfdc9ff71598b87fa9d6efaadf2b25f706630f29ddb44e5b445f395"
    sha256 cellar: :any,                 sonoma:        "970ac3cf05557867cf60c48cc5426cd0703695fa946bcab872291cca1957efc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e49777a1bc398cf8d44f69ad880f12482b632186dbb7482e66d79cc0347dd985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35af178ae26bb39d1dbd4ce4178c4e5e16a980ef2831aa5670b7c4adbb522be"
  end

  head do
    url "https://github.com/libxmq/xmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <root>
      <child>Hello Homebrew!</child>
      </root>
    XML
    output = shell_output("#{bin}/xmq test.xml select //child")
    assert_match "Hello Homebrew!", output
  end
end
