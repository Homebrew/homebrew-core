class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.0.tar.xz"
  sha256 "62ccb213083a7844793c53a9b66e6c3788ab614803a9a6ff1fd04cd87a67267b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "b62ec6f0b871a7b5607b28de185c8299ac29b9f4cabcc407a99609b22572870f"
    sha256 big_sur:       "4265d744d8031396b0ca3e33d8779de961c739fadedff9b021500e73570cbf35"
    sha256 catalina:      "7ce14682f2f90df40d0d14f911c1d311b8f1a0f31e958cba8db4ef210a41382c"
    sha256 mojave:        "e7735ad3286a00c3925a55a806e72a4457f4aea780c3b6aee1346a451d8e69a9"
    sha256 x86_64_linux:  "108f670fb71a41c901d95f4365daafe24ff9784041026de795b734c5143fad48"
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
