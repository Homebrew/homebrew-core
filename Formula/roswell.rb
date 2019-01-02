class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v19.1.10.96.tar.gz"
  sha256 "e295f63f37c1d479af97d711fef925e2177066c2491be51c1fe0ab098cab9dee"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "f26aa80640ed3b95153667017089ea52ba9be8a9e43c648ef90f7706701c17e1" => :mojave
    sha256 "df2487a5d7805bd506db021b6a5d0ed9cd4a49b5d8a09f2156e554163a178961" => :high_sierra
    sha256 "d12cd33d8fa47367503f25c88c1ead0fdaa4778886f92e455492b4dde26056ce" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

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
