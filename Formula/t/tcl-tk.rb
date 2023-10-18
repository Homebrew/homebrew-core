class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tcl8.6.13-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.13-src.tar.gz"
  sha256 "43a1fae7412f61ff11de2cfd05d28cfc3a73762f354a417c62370a54e2caf066"
  license "TCL"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "74132c29be2e0b94b8677f8675c271e4b3157a348c40836b975a5c2bb42a5cc7"
    sha256 arm64_ventura:  "9954fa13ce6b951279337ceac95df1f0a95514e984811e3870e67e96d5be991b"
    sha256 arm64_monterey: "69995b0bb1f27f326f26da7feb252faa90c0a81b84f9fc31fa97ac5c7f85d346"
    sha256 arm64_big_sur:  "66810835803c886015176b754e2d03ca619d5171e7ce7b206bfab6050dbbaafb"
    sha256 sonoma:         "15a86180e3f339dffb1fad34a8800e3dda404084749c5374778e5f87d73e020c"
    sha256 ventura:        "5c42d94815be17612d95eb4e62e88f546a2093386819c9ef857886373df641d9"
    sha256 monterey:       "72212f6d3cd1874634f6c320f02b50f34f296bd30a26d4db3063bd354d9b15a0"
    sha256 big_sur:        "2e645e825dfc8d6fcbd664e5c66b042f5a8784cb33305864867ca9ee6479dbd1"
    sha256 x86_64_linux:   "99f5e8a2effac888f1538a1225af6e8ce70f39dd143adf8d03a35b040089a9b2"
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
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tk8.6.13-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.13-src.tar.gz"
    sha256 "2e65fa069a23365440a3c56c556b8673b5e32a283800d8d9b257e3f584ce0675"

    # Bugfix for ttk::ThemeChanged errors; will be in Tk 8.6.14
    # See https://core.tcl-lang.org/tk/info/310c74ecf4
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/db4f8f774193/x11/tk/files/fix-themechanged-error.patch"
      sha256 "2a75496dc597dec9d25401ab002f290be74d4acd5566793c5114e75a154c280a"
    end

    # Bugfix for KVO crash; will be in Tk 8.6.14
    # See https://core.tcl-lang.org/tk/info/ef5d3e29a4
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/6a93695d61d3/x11/tk/files/fix-kvo-crash.diff"
      sha256 "ec9a9234b4a326e5621fe78e078c29aa4784b6dc88c59a43d828639ebae0af41"
    end
  end

  resource "itk4" do
    url "https://downloads.sourceforge.net/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itk%204.1.0/itk4.1.0.tar.gz"
    mirror "https://src.fedoraproject.org/lookaside/extras/itk/itk4.1.0.tar.gz/sha512/1deed09daf66ae1d0cc88550be13814edff650f3ef2ecb5ae8d28daf92e37550b0e46921eb161da8ccc3886aaf62a4a3087df0f13610839b7c2d6f4b39c9f07e/itk4.1.0.tar.gz"
    sha256 "da646199222efdc4d8c99593863c8d287442ea5a8687f95460d6e9e72431c9c7"
  end

  def install
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
