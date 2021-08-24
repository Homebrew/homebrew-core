class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.85/threadweaver-5.85.0.tar.xz"
  sha256 "431b4a480d200bf12e88ce510efd56edb062eb2284d4233f9602ae62a75da555"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "32608623b3a3193c5152e82fe918f5be2873a2e77a1fa74a8a8188a0cccb1c4b"
    sha256 cellar: :any, big_sur:       "4457f1f5e4090afdf014d231afbaa46ef88eaace6de5637036d75cb03f9d4e38"
    sha256 cellar: :any, catalina:      "5545bb3f7ed94bebdab3d84c6a37b45407a250f35ff479f350279895ca00a84a"
    sha256 cellar: :any, mojave:        "9d7885c469f5ef2862c59512b0b85f244c59b7808478d1eb1e44d7947e3acaef"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
