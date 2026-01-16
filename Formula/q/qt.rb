class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/md5sums"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/md5sums"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/md5sums"
  version "6.10.1"
  sha256 "e7e9670eef892eeab7849ad3de3613c11f150859f601fa78fa893ba6d3862707"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6c41c7a26b3bb79e42e1d40fd6b0db03fb14276af26a62778396bfcce3ad535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c41c7a26b3bb79e42e1d40fd6b0db03fb14276af26a62778396bfcce3ad535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c41c7a26b3bb79e42e1d40fd6b0db03fb14276af26a62778396bfcce3ad535"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c41c7a26b3bb79e42e1d40fd6b0db03fb14276af26a62778396bfcce3ad535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc4dccfcfd038cc0948c61bddfbf2db7c6d0c4c3963354c7879d7ca61b99b4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "134a0f052e792c3cd2da1dbb791372760c979956ff4d2dcaeba66cafc2029797"
  end

  depends_on "cmake" => :test
  depends_on "pkgconf" => :test
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

  on_sonoma :or_newer do
    depends_on "qtwebengine"
    depends_on "qtwebview"
  end

  on_linux do
    depends_on "qtwayland"

    # TODO: Add dependencies on all Linux when `qtwebengine` is bottled on arm64 Linux
    on_intel do
      depends_on "qtwebengine"
      depends_on "qtwebview"
    end
  end

  def webengine_supported?
    on_sonoma :or_newer do
      return true
    end
    on_linux do
      on_intel do
        return true
      end
    end
    false
  end

  def install
    # Check for any new formulae that need to be created before bottling
    if build.bottle?
      # FIXME: brew produces inconsistent filenames as it thinks /qt.io/ in some mirror URLs is a filename
      submodules = File.read(Dir["*"].first).scan(/^\h+[ \t]+(\S+)-everywhere-src-/i).flatten.to_set
      submodules -= ["qtwebengine", "qtwebview"] unless webengine_supported?
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
    modules = %w[Core Gui Widgets Sql Concurrent 3DCore Svg Quick3D Network NetworkAuth]
    modules << "WebEngineCore" if webengine_supported?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      qt_standard_project_setup()
      qt_add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += #{modules.join(" ").downcase}
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
    QMAKE

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
      #{"#include <QtWebEngineCore>" if webengine_supported?}
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
