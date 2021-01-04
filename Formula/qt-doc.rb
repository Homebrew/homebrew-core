class QtDoc < Formula
  desc "Qt Documentation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/6.0/6.0.0/submodules/qtdoc-everywhere-src-6.0.0.tar.xz"
  sha256 "476108d92506d93d5df227f275d653abba57b3b1694afbf2965e0c74e8c0a5a8"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt-tools" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=/usr/local
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja", "docs"
    system "ninja", "install_docs"
    
    Pathname.glob("share/qt/doc/*") do |path|
      doc.install path
    end
  end

  test do
    assert_predicate share/"doc/qt", :exist?
  end
end
