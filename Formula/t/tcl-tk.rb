class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.15/tcl8.6.15-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.15-src.tar.gz"
  sha256 "861e159753f2e2fbd6ec1484103715b0be56be3357522b858d3cbb5f893ffef1"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "5c86b0e5af8d90d098b67726a67dcc2c6a526c8aac2cea25e8fce43e6f57839f"
    sha256 arm64_sonoma:  "2a456668a99adffe53485ceb07961201aac42e582434530ac9e32870a3ac3190"
    sha256 arm64_ventura: "c27c4de6f2e0059d9f8faa87d3f0dbffc5e86d93f4aa472fc2a032596f7e732e"
    sha256 sonoma:        "f72b0c08a6e75d91441f827dde205c772cf0777b9ed9be1a5217e662c40051d5"
    sha256 ventura:       "b7981ed65c43e615854eb40afda733fffa641d2f9d65d26f27cc6bfa90387de5"
    sha256 x86_64_linux:  "f3d4fa58e986a465068f64d36c0a98dd37c3ed74da79b796b9fc90b467ce5bce"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freetype" => :build
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxext"
  end

  conflicts_with "page", because: "both install `page` binaries"
  conflicts_with "the_platinum_searcher", because: "both install `pt` binaries"

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/refs/tags/3.2.tar.gz"
    sha256 "20061944e28dda4ab2098b8f77682cab77973f8961f6fa60b95bcc09a546789e"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.21/tcllib-1.21.tar.xz"
    sha256 "10c7749e30fdd6092251930e8a1aa289b193a3b7f1abf17fee1d4fa89814762f"
  end

  resource "tcltls" do
    url "https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.15/tk8.6.15-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.15-src.tar.gz"
    sha256 "550969f35379f952b3020f3ab7b9dd5bfd11c1ef7c9b7c6a75f5c49aca793fec"
  end

  # "https://downloads.sourceforge.net/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itk%204.1.0/itk4.1.0.tar.gz"
  # would cause `bad URI(is not URI?)` error on 12/13 builds
  resource "itk4" do
    url "https://deb.debian.org/debian/pool/main/i/itk4/itk4_4.1.0.orig.tar.gz"
    mirror "https://src.fedoraproject.org/lookaside/extras/itk/itk4.1.0.tar.gz/sha512/1deed09daf66ae1d0cc88550be13814edff650f3ef2ecb5ae8d28daf92e37550b0e46921eb161da8ccc3886aaf62a4a3087df0f13610839b7c2d6f4b39c9f07e/itk4.1.0.tar.gz"
    sha256 "da646199222efdc4d8c99593863c8d287442ea5a8687f95460d6e9e72431c9c7"
  end

  def install
    odie "tk resource needs to be updated" if version != resource("tk").version

    args = %W[
      --prefix=#{prefix}
      --includedir=#{include}/tcl-tk
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    ENV["TCL_PACKAGE_PATH"] = "#{HOMEBREW_PREFIX}/lib"
    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    # Let tk finds our new tclsh
    ENV.prepend_path "PATH", bin

    resource("tk").stage do
      cd "unix" do
        args << "--enable-aqua=yes" if OS.mac?
        system "./configure", *args, "--without-x", "--with-tcl=#{lib}"
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
        ln_s bin/"wish#{version.to_f}", bin/"wish"
      end
    end

    resource("critcl").stage do
      system bin/"tclsh", "build.tcl", "install"
    end

    resource("tcllib").stage do
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
      system "make", "critcl"
      cp_r "modules/tcllibc", "#{lib}/"
      ln_s "#{lib}/tcllibc/macosx-x86_64-clang", "#{lib}/tcllibc/macosx-x86_64" if OS.mac?
    end

    resource("tcltls").stage do
      system "./configure", "--with-ssl=openssl",
                            "--with-openssl-dir=#{Formula["openssl@3"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    resource("itk4").stage do
      itcl_dir = Pathname.glob(lib/"itcl*").last
      args = %W[
        --prefix=#{prefix}
        --exec-prefix=#{prefix}
        --with-tcl=#{lib}
        --with-tclinclude=#{include}/tcl-tk
        --with-tk=#{lib}
        --with-tkinclude=#{include}/tcl-tk
        --with-itcl=#{itcl_dir}
      ]
      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # Rename all section 3 man pages in the Debian/Ubuntu style, to avoid conflicts
    man3.glob("*.3") { |file| file.rename("#{file}tcl") }

    # Use the sqlite-analyzer formula instead
    # https://github.com/Homebrew/homebrew-core/pull/82698
    rm bin/"sqlite3_analyzer"
  end

  def caveats
    <<~EOS
      The sqlite3_analyzer binary is in the `sqlite-analyzer` formula.
    EOS
  end

  test do
    assert_match "#{HOMEBREW_PREFIX}/lib", pipe_output("#{bin}/tclsh", "puts $auto_path\n")
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp

    # Fails with: no display name and no $DISPLAY environment variable
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    test_itk = <<~EOS
      # Check that Itcl and Itk load, and that we can define, instantiate,
      # and query the properties of a widget.


      # If anything errors, just exit
      catch {
          package require Itcl
          package require Itk

          # Define class
          itcl::class TestClass {
              inherit itk::Toplevel
              constructor {args} {
                  itk_component add bye {
                      button $itk_interior.bye -text "Bye"
                  }
                  eval itk_initialize $args
              }
          }

          # Create an instance
          set testobj [TestClass .#auto]

          # Check the widget has a bye component with text property "Bye"
          if {[[$testobj component bye] cget -text]=="Bye"} {
              puts "OK"
          }
      }
      exit
    EOS
    assert_equal "OK\n", pipe_output("#{bin}/wish", test_itk), "Itk test failed"
  end
end
