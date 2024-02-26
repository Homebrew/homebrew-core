class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/refs/tags/0.15.6.tar.gz"
  sha256 "a3babe5eb284606090af706b356f1a0476123598f680094b1799670ec1780a44"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ec4211428d8a023e0943cdbf200bf44664ba76db66d50289b8d7992af7452dea"
    sha256 cellar: :any, arm64_ventura:  "43ee0b074e08947d548203b93f4d7c34458bdbdea86827ebc64489000937b715"
    sha256 cellar: :any, arm64_monterey: "80b2f906e3e35ad7597eb227fb93a3fc51c3ad219d774e3670c7d796317487d5"
    sha256 cellar: :any, sonoma:         "a35dd06aeca333b8b9be31cccddf6c53ce6ff5cafb93fefc14fb4454dc860d4a"
    sha256 cellar: :any, ventura:        "72b23904cd146f1a6a3a82da8a169c8c44c32028d264a5604e43f66cc746b91d"
    sha256 cellar: :any, monterey:       "332cfd221b67fef580e29d75d5f28ba362ed314c6c5d229321acead3a8dcfbe6"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_EXAMPLE=NO
      -DBUILD_EXAMPLE_SDL=NO
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <wiiuse.h>
      int main()
      {
        int wiimoteCount = 1;
        wiimote** wiimotes = wiiuse_init(wiimoteCount);
        wiiuse_cleanup(wiimotes, wiimoteCount);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-l", "wiiuse", "-o", "test"
    system "./test"
  end
end
