class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/md5sums.txt"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/md5sums.txt"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/md5sums.txt"
  version "6.9.3"
  sha256 "6da59a97380cfb2dd7e93c8172e794f2cc2ccc6ab29620689932ee3b8169c964"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]

  livecheck do
    formula "qtbase"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "21254c8c796c8e2c9a0b29a465f45ea1d2831930847d9de1c30f2333befb9de4"
    sha256 cellar: :any, arm64_sequoia: "b51bc26874d98507975fb7bb8b5e43f0fa617c503f9b56923d0196016ea1894a"
    sha256 cellar: :any, arm64_sonoma:  "3e783ecc24d44882a75c8ea62da58428b303d57ace8cd00ce351e8aa5160c25c"
    sha256 cellar: :any, sonoma:        "e5f574692f7586ef2674b2a4bb5e24f6ccf77ee7cce15a827126a0142c723a22"
    sha256               x86_64_linux:  "0b405353963f49dabb10fb0697ca5dae05d025ae37efb57d22e1aa66ecc381bc"
  end

  depends_on "vulkan-headers" => :test

  depends_on "qt3d"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtconnectivity"
  depends_on "qtdatavis3d"
  depends_on "qtdeclarative"
  depends_on "qtgraphs"
  depends_on "qtgrpc"
  depends_on "qthttpserver"
  depends_on "qtimageformats"
  depends_on "qtlanguageserver"
  depends_on "qtlocation"
  depends_on "qtlottie"
  depends_on "qtmultimedia"
  depends_on "qtnetworkauth"
  depends_on "qtpositioning"
  depends_on "qtquick3d"
  depends_on "qtquick3dphysics"
  depends_on "qtquickeffectmaker"
  depends_on "qtquicktimeline"
  depends_on "qtremoteobjects"
  depends_on "qtscxml"
  depends_on "qtsensors"
  depends_on "qtserialbus"
  depends_on "qtserialport"
  depends_on "qtshadertools"
  depends_on "qtspeech"
  depends_on "qtsvg"
  depends_on "qttools"
  depends_on "qttranslations"
  depends_on "qtvirtualkeyboard"
  depends_on "qtwebchannel"
  depends_on "qtwebsockets"

  on_system :linux, macos: :sonoma_or_newer do
    depends_on "qtwebengine"
    depends_on "qtwebview"
  end

  on_linux do
    depends_on "qtwayland"
  end

  def install
    # Check for any new formulae that need to be created before bottling
    if build.bottle?
      submodules = File.read("md5sums.txt").scan(/^\h+[ \t]+(\S+)-everywhere-src-/i).flatten.to_set
      submodules -= ["qtwebengine", "qtwebview"] if OS.mac? && MacOS.version < :sonoma
      submodules.delete("qtwayland") unless OS.linux?
      submodules.delete("qtactiveqt") # Windows-only
      submodules.delete("qtdoc") # skip HTML documentation

      dep_names = deps.reject(&:test?).to_set(&:name)
      missing = submodules - dep_names
      odie "Possible new #{Utils.pluralize("formula", missing.count)}: #{missing.join(", ")}" unless missing.empty?
      extras = dep_names - submodules
      odie "Unexpected #{Utils.pluralize("dependency", extras.count)}: #{extras.join(", ")}" unless extras.empty?
    end

    # Create compatibility symlinks so existing usage of `Formula["qt"]` still works.
    # These are done pointing to HOMEBREW_PREFIX paths to avoid making `qt` keg-only
    # which causes an unwanted caveat message. Anyways, Qt won't work correctly if
    # any dependencies are not linked as it is built to find modules in linked path
    deps.each do |dep|
      next if dep.test?

      formula = dep.to_formula
      Find.find(*formula.opt_prefix.glob("{#{Keg.keg_link_directories.join(",")}}")) do |src|
        src = Pathname(src)
        dst = prefix/src.relative_path_from(formula.opt_prefix)
        linked_src = HOMEBREW_PREFIX/src.relative_path_from(formula.opt_prefix)

        # Skip directories that have been symlinked already. We just link all directories
        # starting with "Qt", which helps reduce the total number of symlinks by over 90%.
        Find.prune if dst.symlink?

        if src.symlink? || src.file?
          dst.dirname.install_symlink linked_src
        elsif src.directory? && (linked_src.symlink? || src.basename.to_s.start_with?(/qt/i))
          dst.dirname.install_symlink linked_src
          Find.prune
        end
      end

      # Also symlink apps from libexec directories. Need to use ln_s to retain opt path
      formula.opt_libexec.glob("*.app") do |app|
        libexec.mkpath
        ln_s app.relative_path_from(libexec), libexec
      end
    end
  end

  test do
    webengine_supported = !OS.mac? || MacOS.version > :ventura
    modules = %w[Core Gui Widgets Sql Concurrent 3DCore Svg Quick3D Network NetworkAuth]
    modules << "WebEngineCore" if webengine_supported

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~EOS
      QT += #{modules.join(" ").downcase}
      TARGET = test
      CONFIG += console
      CONFIG -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
    EOS

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <QVulkanInstance>
      #{"#include <QtWebEngineCore>" if webengine_supported}
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication app(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        QVulkanInstance inst;
        // See https://github.com/actions/runner-images/issues/1779
        // if (!inst.create())
        //   qFatal("Failed to create Vulkan instance: %d", inst.errorCode());
        for(const char* fmt:{"bmp", "cur", "gif",
          #ifdef __APPLE__
            "heic", "heif",
          #endif
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"

    # Check QT_INSTALL_PREFIX is HOMEBREW_PREFIX to support split `qt-*` formulae
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/qmake -query QT_INSTALL_PREFIX").chomp
  end
end
