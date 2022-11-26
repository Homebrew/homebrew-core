class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tcl8.6.13-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.13-src.tar.gz"
  sha256 "43a1fae7412f61ff11de2cfd05d28cfc3a73762f354a417c62370a54e2caf066"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "55a38f29acf61f16d9a7d91546e14bb102708b9ece4dce5e243cf94a22134259"
    sha256 arm64_monterey: "03f3d27e2c369dc54fd6ddf037991c7c9eb3bf1e4af9efea87a5f0425cc171d8"
    sha256 arm64_big_sur:  "f9f9c8e0e9fbea41b9a2890045a2a01f94a74ac8890e49406cc098782fb7e4d3"
    sha256 ventura:        "6891661ab80a18459d23ac3ebaffa9def7e996bd6f15f229a1a5291faad047fd"
    sha256 monterey:       "ca15b6e71d81499f80bce95b854138b07bc3843fc8c8d832edef1585da698996"
    sha256 big_sur:        "7d61f627dce342477e4ebd5e86c226fa2aa77dde6e1e0feb6ae3b5f54cecb7cd"
    sha256 catalina:       "a6c5e70dcaa9144148b330f06af8209ddae6a6438799ed6aea3d0ca4d97c5444"
    sha256 x86_64_linux:   "d519790e632e4f6d8ce636c09eef1847335c959ff1ed87d71a7535b27ec53d80"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freetype" => :build
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxext"
  end

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/3.1.18.1.tar.gz"
    sha256 "51bc4b099ecf59ba3bada874fc8e1611279dfd30ad4d4074257084763c49fd86"
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
  end

  resource "itk4" do
    url "https://downloads.sourceforge.net/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itk%204.1.0/itk4.1.0.tar.gz"
    sha256 "da646199222efdc4d8c99593863c8d287442ea5a8687f95460d6e9e72431c9c7"
  end

  def install
    args = %W[
      --prefix=#{prefix}
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
                            "--with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}",
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
        --with-tk=#{lib}
        --with-itcl=#{itcl_dir}
      ]
      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # Conflicts with perl
    mv man/"man3/Thread.3", man/"man3/ThreadTclTk.3"

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
