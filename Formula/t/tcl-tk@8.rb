class TclTkAT8 < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.17/tcl8.6.17-src.tar.gz"
  sha256 "a3903371efcce8a405c5c245d029e9f6850258a60fa3761c4d58995610949b31"
  license "TCL"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(8(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1797f9f71b4169c08c9d205629b6ab156d9b56fdab63bc8cbde37c4996dd17e3"
    sha256 arm64_sequoia: "3a4f0641ea67fbe31c387c47ffbc8bb7730d64d491e54d80a83b1d3909e36d9d"
    sha256 arm64_sonoma:  "6a37964adf5d0a0ffbed08421bc0cfa5921dd1425d553c32bf0c921e8f90ddd3"
    sha256 sonoma:        "c59a63f6c4e2bac8890a47ddd169555f5f533b4559b46fc034e3225d38443346"
    sha256 arm64_linux:   "e6d29135b80a56c2c73d0ba2c55b281bdee37c6fb5dddb9dca26713ef2d40e69"
    sha256 x86_64_linux:  "e94936d57ac2edba0fbdcfe41fa62944683cc8e9f9a6e5b376f91f05a28abd7e"
  end

  keg_only :versioned_formula

  depends_on "openssl@4"

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

    # OpenSSL 4 makes ASN1_UTCTIME opaque.
    patch :DATA
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
                            "--with-openssl-dir=#{Formula["openssl@4"].opt_prefix}",
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

__END__
diff --git a/tlsX509.c b/tlsX509.c
index afde377..961b1f0 100644
--- a/tlsX509.c
+++ b/tlsX509.c
@@ -38,11 +38,13 @@ ASN1_UTCTIME_tostr(ASN1_UTCTIME *tm)
         "Jan","Feb","Mar","Apr","May","Jun",
         "Jul","Aug","Sep","Oct","Nov","Dec"};
     int i;
+    const unsigned char *data;
     int y=0,M=0,d=0,h=0,m=0,s=0;
     
-    i=tm->length;
-    v=(char *)tm->data;
-    
+    i=ASN1_STRING_length(tm);
+    data=ASN1_STRING_get0_data(tm);
+    v=(char *)data;
+    
     if (i < 10) goto err;
     if (v[i-1] == 'Z') gmt=1;
     for (i=0; i<10; i++)
