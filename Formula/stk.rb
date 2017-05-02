class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.5.1.tar.gz"
  sha256 "3466860901a181120d3bd0407e4aeb5ab24127a4350c314af106778c1db88594"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c344b00f598b39142e6dcc1c89014285bbe262cb5da0fff0c541d3030fd2ec4" => :sierra
    sha256 "15e49e8bd743392c616b9d7b1475e90b42f0d0850062cb4ab04b7462da0162d3" => :el_capitan
    sha256 "d121a9d4cb0e4b9cde3bc8a2cf304e39bc2e5520506decb7e1464cdc151e4317" => :yosemite
  end

  option "with-debug", "Compile with debug flags and modified CFLAGS for easier debugging"

  deprecated_option "enable-debug" => "with-debug"

  fails_with :clang do
    build 421
    cause "due to configure file this application will not properly compile with clang"
  end

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "debug"
      inreplace "configure", 'CFLAGS="-g -O2"', 'CFLAGS="-g -O0"'
      inreplace "configure", 'CXXFLAGS="-g -O2"', 'CXXFLAGS="-g -O0"'
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS $cppflag"', ' CPPFLAGS="$CPPFLAGS $cppflag -g -O0"'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats; <<-EOS.undent
    The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

      #include \"stk/FileLoop.h\"
      #include \"stk/FileWvOut.h\"

    src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end
end
