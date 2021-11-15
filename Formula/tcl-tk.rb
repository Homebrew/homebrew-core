class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.12/tcl8.6.12-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.12-src.tar.gz"
  sha256 "26c995dd0f167e48b11961d891ee555f680c175f7173ff8cb829f4ebcde4c1a6"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "5faf1681a1a424487d580601238ecc1f3d83fd11db6ac237683f314e9b21dcf0"
    sha256 arm64_big_sur:  "a2fab3435e8e70bc55af3497f55a169c52d7a4567a9c9e8affc17c26ba3ccadd"
    sha256 monterey:       "c50ec17604de23c4a82165cf24cc402de0aa480e6fff7a805dc638eb88610e35"
    sha256 big_sur:        "71c450d2b7a19364c07d09a08434692dd2aaeaf3afe478566e984ef90ed28194"
    sha256 catalina:       "0a7368698d7fe08e77efc96a99d2d20ae0611906bac7454e64049790cc298e77"
    sha256 x86_64_linux:   "d1ca9796772743d35c5671771969c7db998493a94f8bfc285b4b46c0050e7d54"
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
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.20/tcllib-1.20.tar.xz"
    sha256 "199e8ec7ee26220e8463bc84dd55c44965fc8ef4d4ac6e4684b2b1c03b1bd5b9"
  end

  resource "tcltls" do
    url "https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.12/tk8.6.12-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.12-src.tar.gz"
    sha256 "12395c1f3fcb6bed2938689f797ea3cdf41ed5cb6c4766eec8ac949560310630"
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
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp

    on_linux do
      # Fails with: no display name and no $DISPLAY environment variable
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

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
