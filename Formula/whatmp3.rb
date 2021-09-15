class Whatmp3 < Formula
  include Language::Python::Shebang

  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  license "MIT"
  revision 4
  head "https://github.com/RecursiveForest/whatmp3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2508dc07fce36d65efad6e315157faf498789a43e0d8f9eb595ea8122250d6bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "68a5f39de733c7d95679ac3e9c91e9edd543eb9450592a517b2491dd7089641b"
    sha256 cellar: :any_skip_relocation, catalina:      "d449a8bb1339bbc02f27b930a08c21f2acfdbbb49f45dd43ea4015054607244f"
    sha256 cellar: :any_skip_relocation, mojave:        "73e35194bc0eed4cab900ae2436ca67283bddc942d73a77f84e3aa02cf2e518a"
    sha256 cellar: :any_skip_relocation, high_sierra:   "87e78b789996ff11ea55d9224896d581d0aff8a6ad10e14e456588903cf592cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96b8eef9263818c2f0c41793b96f38828a2837390c90cef40f5d8845a65194c"
  end

  depends_on "flac"
  depends_on "lame"
  depends_on "mktorrent"
  depends_on "python@3.9"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    rewrite_shebang detected_python_shebang, bin/"whatmp3"
  end

  test do
    (testpath/"flac").mkpath
    cp test_fixtures("test.flac"), "flac"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath/"V0/test.mp3", :exist?
  end
end
