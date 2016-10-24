class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.2.tar.xz"
  sha256 "765e9c2b429a66db93247940f8588319b43f35c173d057bcae5717a97d765c41"

  bottle do
    sha256 "b0cd68f890df8fc5486cce5292a3df30c53809263cd68f17eb2830240ac95ab1" => :sierra
    sha256 "0ee9e476f968b2110ff1084013d97c17e0257600e68440e11ee043633774ba82" => :el_capitan
    sha256 "1a7d0da3cedf53d39eb09bcf1b8970964f5f03b473d87ad617d3c6c5e1165fc5" => :yosemite
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
