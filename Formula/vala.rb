class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.3.tar.xz"
  sha256 "f0fad71aca03cdeadf749ca47f56296a4ddd1a25f4e2f09f0ff9e1e3afbcac3f"

  bottle do
    sha256 "c3a7d628cdea0d219285c0ca15334837702856614237ba97aea6cf525ebfc25a" => :sierra
    sha256 "643c1f0a2c46535b4c67aa2ab452ff585aee04fbf7234d2dea2306fb81af822b" => :el_capitan
    sha256 "2e8ab158fe83cb986bcc69a750c12000a14343e0f60a932428a9d4b5e1c3aefb" => :yosemite
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
