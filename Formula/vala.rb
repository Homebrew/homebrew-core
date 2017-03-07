class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.6.tar.xz"
  sha256 "d1e32d6c55c2d66964d30b7410b78f5f313f1231fc3502da9980c3c80a797bb1"

  bottle do
    sha256 "832c9aecdc4ab15ea9cdd433365fb4b2927a9e92f45ffe5b5067018369fb79dd" => :sierra
    sha256 "6a597b275d6390ca13a2b8e5181753b08eb33b2c4bf3d71845449ff2bbd207fa" => :el_capitan
    sha256 "5d0671332c699f15a31d58bbf9644cf3a4da0eabe8100b4b7520898b1aaa11e6" => :yosemite
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
