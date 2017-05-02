class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.36/vala-0.36.3.tar.xz"
  sha256 "ac8a4ecd01f62d0c5f62ba50b7290d8c5a1edb308eec772a65b8e79be68f061c"

  bottle do
    sha256 "67cb955d82517944a7468aeb5b1aca1a867d55b7ea512867913d77cff6530d0e" => :sierra
    sha256 "e44f3afc318d02f9cb616542ac740a4c9df71d0aa24bcae97e44eb2879faf34a" => :el_capitan
    sha256 "245cade95b8a3c050048e71bf6b865602c1a144828ea0331cdf956912467041a" => :yosemite
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
