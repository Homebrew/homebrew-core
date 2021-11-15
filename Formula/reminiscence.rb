class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.4.8.tar.bz2"
  sha256 "1cb6ccb4ac9ec38fa80dd80dbdb24ccf16cf58d2de42a030776a3a7c691cabf8"

  livecheck do
    url :homepage
    regex(/href=.*?REminiscence[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "91639903b56ed2aa55f8329fff597584f809f650187cd8544d23c97446781253"
    sha256 cellar: :any,                 arm64_big_sur:  "e5f1b6bbae4b98d7b63fc625185777507337626a291562e40e9bf43a5b5cd07a"
    sha256 cellar: :any,                 monterey:       "4fa80b24949f6a09c5502dd19ca50f15959751cd11beabf6141f48498673531a"
    sha256 cellar: :any,                 big_sur:        "d9ce59c1d7e918e95c41ab0634f37296716d81985463b066415c5cd311e23a1b"
    sha256 cellar: :any,                 catalina:       "6e2a4eae17d7c5344f2fdcf4c23214fba760d039e9a5d9a1ba6d9236684a9331"
    sha256 cellar: :any,                 mojave:         "267a60d456e2223523e09144575cab1d5b6087b8e52c4bb6715450ee00fa60ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d48b92bd2765f37d9d8fe7d533f3cda688baa711e34eab8a5ccadfb36998ef2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  uses_from_macos "zlib"

  resource "tremor" do
    url "https://gitlab.xiph.org/xiph/tremor.git",
        revision: "7c30a66346199f3f09017a09567c6c8a3a0eedc8"
  end

  def install
    resource("tremor").stage do
      system "./autogen.sh", "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{libexec}",
                             "--disable-static"
      system "make", "install"
    end

    ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
    ENV.prepend "LDFLAGS", "-L#{libexec}/lib"
    if OS.linux?
      # Fixes: reminiscence: error while loading shared libraries: libvorbisidec.so.1
      ENV.append "LDFLAGS", "-Wl,-rpath=#{libexec}/lib"
    end

    system "make"
    bin.install "rs" => "reminiscence"
  end

  test do
    system bin/"reminiscence", "--help"
  end
end
