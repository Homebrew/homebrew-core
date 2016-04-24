class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.5.62.tar.gz"
  sha256 "9ca42a849914ada9c9da495205c9d0cdade4d3b39cd7ac38821bacc1a4ef638a"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "e788de3677cba691bd2197a067fff66d961b776590529081b4e554a1e5803a24" => :el_capitan
    sha256 "b2bdbd13311e5363dfde0973d7db06a6580da4edc483dd7f8e313f524d0a178c" => :yosemite
    sha256 "ae376fc09deabafcad4440ff0612e398817a259e19c0690741da0a81a41f035f" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-manual-generation",
                          "--enable-html-generation",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    File.exist? testpath/".roswell/config"
  end
end
