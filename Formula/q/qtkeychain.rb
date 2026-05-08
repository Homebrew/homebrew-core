class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.16.0.tar.gz"
  sha256 "3be26ec4ae30eecf0c2ff7572ba83799791b157c76e15a05ef35f23dc25e4054"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41f6d22dfd217ea9b48f9c04f870110de63ae4976058fb2f0440b809f89ca0d0"
    sha256 cellar: :any,                 arm64_sequoia: "ba494276b36b760cfe65977b69b17c512f56fd44702a51597249f68f3ba7c7af"
    sha256 cellar: :any,                 arm64_sonoma:  "043664ceb869b0cddd4cea963e93f8c7ae59a891ac26577e88e5bb167c21fca1"
    sha256 cellar: :any,                 sonoma:        "9ed1e42e2b34aecfdfb1a2fc9a8c3956331929ec80e12a058c287a2238b3e244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48eb663efa321d756a6ba5c367b48424df7774a805a45835c28be6aa9189846a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c306524e585af4bfbe79793e2146de8caf466d26bc12568640964464fffa243"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qtbase"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    args = %w[-DBUILD_TRANSLATIONS=OFF -DBUILD_WITH_QT6=ON]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <qt6keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    CPP
    flags = ["-I#{Formula["qtbase"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qtbase"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qtbase"].opt_lib}", "-lQt6Core",
        "-Wl,-rpath,#{Formula["qtbase"].opt_lib}",
        "-Wl,-rpath,#{lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17", "-I#{include}",
                    "-L#{lib}", "-lqt6keychain", *flags
    system "./test"
  end
end
