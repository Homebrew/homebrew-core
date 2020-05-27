class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v20.05.14.106.tar.gz"
  sha256 "df479d3e8df824f3e2cfccf59e49b1cbcceedf51f188628eb705da3964e7ca71"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "04cd5b04dd79c36d85cf8b09077b67133245488b6c6c6c6b2b7c2cdeb8558a43" => :catalina
    sha256 "06227b48759a27b8fcfcc3480de263e704734a218727601c6aa834dd6b1caa7a" => :mojave
    sha256 "13d4a4d43cbc7f2ea4015af1f822ba080864cf1b936b1fb0fcd3b97e89eb1b71" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
