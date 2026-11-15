class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/9.1.0/tcl9.1.0-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl9.1.0-src.tar.gz"
  sha256 "536c45543f64d6eb11832d97ba3494aacff046fbc5040273bd55258d0e448ff1"
  license "TCL"
  compatibility_version 2

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "e9dcfc12059b2fee336ef75e8b0c1d206d7a11f28e7548a16380e6f0f6651021"
    sha256 arm64_tahoe:       "f6e3459c6d92274911c795f794e5cbae42be7f8d0a69a3b399eced8482ab6fb3"
    sha256 arm64_sequoia:     "efe600abce3a5ea633349a78b04930a026f64ea2093943e1c45d47c0204b2232"
    sha256 arm64_linux:       "c9838590fc6e10a10efd572ef90261fc7f534a43545240785cae59f518687d8d"
    sha256 x86_64_linux:      "924b1b2be4276d84a569f25bd14f9e3c1b594a02386118155c507ff98fb2779c"
  end

  depends_on "libtommath"

  on_linux do
    depends_on "freetype" => :build
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "harfbuzz"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxft"
    depends_on "libxrender"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "page", because: "both install `page` binaries"
  conflicts_with "the_platinum_searcher", because: "both install `pt` binaries"

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/refs/tags/3.3.1.tar.gz"
    sha256 "d970a06ae1cdee7854ca1bc571e8b5fe7189788dc5a806bce67e24bbadbe7ae2"

    livecheck do
      url :url
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/2.0/tcllib-2.0.tar.xz"
    sha256 "642c2c679c9017ab6fded03324e4ce9b5f4292473b62520e82aacebb63c0ce20"

    livecheck do
      url "https://sourceforge.net/projects/tcllib/rss?path=/tcllib"
      regex(%r{url=.*?/tcllib[._-]v?(\d+(?:\.\d+)+)\.t}i)
    end
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/9.1.0/tk9.1.0-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk9.1.0-src.tar.gz"
    sha256 "772ce7a97c07c2db4c957c93af7ab4dff4bd3037772836b6afbcd0974023b3d6"

    livecheck do
      formula :parent
    end
  end

  # "https://downloads.sourceforge.net/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itk%204.1.0/itk4.1.0.tar.gz"
  # would cause `bad URI(is not URI?)` error on 12/13 builds
  # Also need a newer release than available on SourceForce for TCL 9
  # so we use the GitHub mirror which is easier to access than Fossil
  resource "itk4" do
    url "https://github.com/tcltk/itk/archive/refs/tags/itk-4-2-3.tar.gz"
    version "4.2.3"
    sha256 "bc5ed347212fce403e04d3161cd429319af98da47effd3e32e20d2f04293b036"

    livecheck do
      url :url
      regex(/^itk[._-]v?(\d+(?:[._-]\d+)+)$/i)
      strategy :git do |tags, regex|
        tags.filter_map { |tag| tag[regex, 1]&.tr("_-", ".") }
      end
    end
  end

  deny_network_access!

  def install
    odie "tk resource needs to be updated" if version != resource("tk").version

    # Remove bundled libraries. Some private headers are still needed
    ["compat/zlib", "libtommath"].each do |dir|
      (buildpath/dir).find do |path|
        rm(path) if path.file? && path.extname != ".h"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --includedir=#{include}/tcl-tk
      --mandir=#{man}
      --disable-zipfs
      --enable-man-suffix
      --enable-64bit
    ]

    ENV["TCL_PACKAGE_PATH"] = "#{HOMEBREW_PREFIX}/lib"
    cd "unix" do
      system "./configure", *args, "--with-system-libtommath"
      # Install the core first so the bundled packages' configure can run tclsh
      system "make", "install-binaries"
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

    resource("itk4").stage do
      itcl_dir = lib.glob("itcl*").last
      # Workaround to build non-release tarball by using TEA files from itcl
      odie "Update `itk4` build step!" if Pathname("tclconfig").exist?
      Pathname.pwd.install_symlink buildpath/"pkgs/#{itcl_dir.basename}/tclconfig"

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
      TclTLS extension is now in the `tcltls` formula.
    EOS
  end

  test do
    if OS.mac?
      ENV["CFFIXED_USER_HOME"] = testpath
      (testpath/"Library/Caches").mkpath
    end

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
