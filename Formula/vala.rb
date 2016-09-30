class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.0.tar.xz"
  sha256 "5d59e1ad4c59debc83687b593345a3cf9ef2e9020354145e59a188de4348f455"

  bottle do
    sha256 "44202ef8e2089412ee3963c482a6da151f36e42ba61cdf440e6f85b0da3f7390" => :sierra
    sha256 "b145fd3b3a57d95e90ff2b0ee093e0f29871687bab4af8a2f50ed76410663ccb" => :el_capitan
    sha256 "7838ebeb324f2b6ec511874389732d4816ec8cb34996858f641220530e4483c6" => :yosemite
    sha256 "b4f091f677a6fe7f3f67e7dc086ce9ca58dc8dcb70a2a786e9f0f029ed67f12c" => :mavericks
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
