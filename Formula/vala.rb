class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.6.tar.xz"
  sha256 "d1e32d6c55c2d66964d30b7410b78f5f313f1231fc3502da9980c3c80a797bb1"

  bottle do
    sha256 "094d4078b7c8a76e068d43e676fabd8cb12e48cc55adb023cd5b31ec93f21d59" => :sierra
    sha256 "314783a1f04fb74d5c766f6e3d0ebb435dd269c6a6ababb8230474ba50b39127" => :el_capitan
    sha256 "323a5d39176c01b0586ea517c35be7a7b62cbd5b23df812a603d1ac13b0c1867" => :yosemite
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<-EOS
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
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
