class Qtwebkit < Formula
  desc "Qt port of WebKit"
  homepage "https://trac.webkit.org/wiki/QtWebKit"
  url "https://download.qt.io/official_releases/qt/5.9/5.9.1/submodules/qtwebkit-opensource-src-5.9.1.tar.xz"
  sha256 "28a560becd800a4229bfac317c2e5407cd3cc95308bc4c3ca90dba2577b052cf"

  keg_only <<-EOS.undent
    "WebKit Framework" provided by osx.
    But system's one is built from WebKitGtk+
  EOS

  option "without-webkit2", "Don't build webkit2"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "qt" => [:build, :run]

  def install
    ENV["QTDIR"] = Formula["qt"].opt_prefix
    cd "Tools/Scripts" do
      system "./set-webkit-configuration", "--release"
      args = %w[--release --qt]
      args << "--no-webkit2" if build.without? "webkit2"
      system "./build-webkit", *args
    end

    cd buildpath/"WebKitBuild/Release" do
      prefix.install "bin", "lib"
      (prefix/"qml").install Dir["imports/*"]
    end
    prefix.install "include"
  end

  def caveats; <<-EOS.undent
    We agreed to the WebKit opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end

  test do
    TestBrowser = fork do
      exec "#{bin}/QtTestBrowser"
    end

    sleep 5

    Process.kill("TERM", TestBrowser)
  end
end
