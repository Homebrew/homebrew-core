class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.36/vala-0.36.1.tar.xz"
  sha256 "13f4a3f99d983bf76e8d9dd736021ecc95f53ec1f9582423aa4b4be87455aa07"

  bottle do
    sha256 "26ad1c6cd447d6eaeb466d759bfd5b31b221a93f314451bdf9d22d842f142d82" => :sierra
    sha256 "415402740b9986d4a78506b790053e057853ede0ea234a047780530680eaeeec" => :el_capitan
    sha256 "72517b846996c0bc8e46fde47e54e5a357c0f4138c538b7f74441b8cba7d7c80" => :yosemite
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
