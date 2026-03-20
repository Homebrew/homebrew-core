class TclTkAT8 < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.17/tcl8.6.17-src.tar.gz"
  sha256 "a3903371efcce8a405c5c245d029e9f6850258a60fa3761c4d58995610949b31"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(8(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c3cef13113dc7af58e7636256289cea7e3f362347f06f96e9417895f5c84494d"
    sha256 arm64_sequoia: "a5dc8687fecd89ea1ce437a409f3e8938161f8f9fd728679d7ba98aaf9a4a121"
    sha256 arm64_sonoma:  "5d0e9ae8eebb1e442cb2c27d491b90ac1fdb4b97f0403eaf4de208c1ef2a499c"
    sha256 sonoma:        "06138d4241d0aa4b4b552dde04215678194643cb5435067b43cf0e8be2b5551e"
    sha256 arm64_linux:   "baea2f270066d9f00cdb3fc43d4657e1c566d21965b6602cefa310c6bbf586ab"
    sha256 x86_64_linux:  "dd71d9dee7ad8ff7ac1306e5696471b106ed15081dbf3ff227173a1bccc78fdc"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"

  on_linux do
    depends_on "freetype" => :build
    depends_on "pkgconf" => :build
    depends_on "libx11"
    depends_on "libxext"
    depends_on "zlib-ng-compat"
  end

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/refs/tags/3.3.1.tar.gz"
    sha256 "d970a06ae1cdee7854ca1bc571e8b5fe7189788dc5a806bce67e24bbadbe7ae2"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/2.0/tcllib-2.0.tar.xz"
    sha256 "642c2c679c9017ab6fded03324e4ce9b5f4292473b62520e82aacebb63c0ce20"
  end

  resource "tcltls" do
    url "https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.17/tk8.6.17-src.tar.gz"
    sha256 "e4982df6f969c08bf9dd858a6891059b4a3f50dc6c87c10abadbbe2fc4838946"

    livecheck do
      formula :parent
    end
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

    # Remove bundled zlib
    rm_r("compat/zlib")

    args = %W[
      --prefix=#{prefix}
      --includedir=#{include}/tcl-tk
      --mandir=#{man}
      --enable-man-suffix
      --enable-threads
      --enable-64bit
    ]

    ENV["TCL_PACKAGE_PATH"] = "#{HOMEBREW_PREFIX}/lib"
    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      bin.install_symlink "tclsh#{version.to_f}" => "tclsh"
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
        bin.install_symlink "wish#{version.to_f}" => "wish"
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
      itcl_dir = lib.glob("itcl*").last
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

    test_itk = <<~TCL
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
    TCL
    assert_equal "OK\n", pipe_output("#{bin}/wish", test_itk), "Itk test failed"
  end
end
