class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag => "v0.7.4",
      :revision => "ca84080b2c857de6951f154886bb7ed5fa100149"

  bottle do
    sha256 "4162068d6ede326a5419c795bfb9fb017d084bf561134e753d0bc5ea39c12a08" => :sierra
    sha256 "6da7e85a81d46691f96b425302a4dbc15b5bbfd41d2e7a12751de2937e3bf8b9" => :el_capitan
    sha256 "b53e4ac2e5bf222d6f64092d44f2dbdd318b7362db3bb10ab3c114dcbae6837a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on :osxfuse

  def install
    ENV.prepend "PKG_CONFIG_PATH", Formula["openssl"].opt_lib/"pkgconfig"

    Dir.chdir "trunk" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xmount", "--version"
  end
end
