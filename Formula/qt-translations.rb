class QtTranslations < Formula
  desc "Translations for Qt Tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/6.0/6.0.0/submodules/qttranslations-everywhere-src-6.0.0.tar.xz"
  sha256 "ed6487425c17e88531e825c44820c1f47c9b7dc0918125e5d45ccc36fdc679d5"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qt-tools"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=/usr/local
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"
  end

  test do
    assert_predicate share/"qt/translations", :exist?
  end
end
