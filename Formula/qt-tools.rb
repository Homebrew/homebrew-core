class QtTools < Formula
  desc "Qt utilities"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/6.0/6.0.0/submodules/qttools-everywhere-src-6.0.0.tar.xz"
  sha256 "b6dc559db447bf394d09dfb238d5c09108f834139a183888179e855c6566bfae"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "llvm" # need cmake related files
  depends_on "qt-base"

  def install
    # See qt-base
    args =std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=/usr/local
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DLLVM_INSTALL_DIR=#{Formula["llvm"].opt_prefix}
    ]

    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # FIXME: this step just moves `*.app` bundles into `libexec` and create link
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec
      bin.install_symlink "#{libexec/app.stem}.app/Contents/MacOS/#{app.stem}"
    end
  end

  test do
    # test `qtpaths`
    assert_equal "/usr/local", `qtpaths --install-prefix`.strip

    # test `qtdoc`
    (testpath/"test.qdocconf").write <<~EOS
      project = test
      outputdir   = html
      headerdirs  = .
      sourcedirs  = .
      exampledirs = .
      imagedirs   = .
    EOS
    system bin/"qdoc", testpath/"test.qdocconf"
    assert_predicate testpath/"html/test.index", :exist?
  end
end
