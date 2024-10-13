class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  # A mirror is used as the primary URL because the official one rate limits
  # too heavily that CI almost always fails.
  url "https://pkg.freebsd.org/ports-distfiles/REminiscence-0.5.1.tar.bz2"
  mirror "http://cyxdown.free.fr/reminiscence/REminiscence-0.5.1.tar.bz2"
  sha256 "6b02b8568a75af5fbad3b123d2efe033614091d83f128bc7f3b8b533db6e4b29"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "887a653149cd8f77383f4f3ffdac106f8dcba9c52987c4a1c17157db04c33b32"
    sha256 cellar: :any,                 arm64_monterey: "98ebed8348cdac56e1a8d02070321635fce264f93934d1f1b3f26489e7a72c05"
    sha256 cellar: :any,                 arm64_big_sur:  "51074efe55bd91ca2d558dee1aa8e981d10ab4701c1a6a8aabbe405805694a8e"
    sha256 cellar: :any,                 ventura:        "31bcc080a553f05b51ed717d28d351018f4923e72c94e0fad630147b2f9be6ed"
    sha256 cellar: :any,                 monterey:       "44157f3569ca1271e725be5627e8518fe6c07087045dc1a5455f5d67b2a0e9ee"
    sha256 cellar: :any,                 big_sur:        "ebeeb228a43e965ea400a36fd035b515e6b648854bbf96159042d95299173ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b09c3a5ffbfc0bd191c3290731350a1a341b6e48065bf60ac2c5b805a035dd"
  end

  # also the repo is archived
  disable! date: "2024-01-06", because: :no_license

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  uses_from_macos "zlib"

  resource "stb_vorbis" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679ca2ef753a528db5ba6801e1067b40481b8/stb_vorbis.c"
    version "1.22"
    sha256 "4c7cb2ff1f7011e9d67950446b7eb9ca044f2e464d76bfbb0b84dd2e23e65636"
  end

  resource "tremor" do
    url "https://gitlab.xiph.org/xiph/tremor.git",
        revision: "7c30a66346199f3f09017a09567c6c8a3a0eedc8"
  end

  def install
    resource("stb_vorbis").stage do
      buildpath.install "stb_vorbis.c"
    end

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
