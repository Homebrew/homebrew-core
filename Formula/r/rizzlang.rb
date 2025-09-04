class Rizzlang < Formula
  desc "Rizz++ - small GenZ-style toy language"
  homepage "https://github.com/Sriyush/RizzLang"
  url "https://github.com/Sriyush/RizzLang/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "d9af95a6cbe8cf2ae9078bb0315acefb6e6c6569da305594a3e32c9197bfbef4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f76dee4dcb874fbc8ea6dab094ee60771f8c2432fa3b841631c989ba8db1f78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0042bc8eebddc4ef9578aec85e3f8cd0f30c3e69caf6c3f4a3a17431330750d0"
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-15"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-15"

    ENV["LDFLAGS"] = "-Wl,-rpath,#{Formula["gcc"].opt_lib}"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/rizz", "--version"
  end
end
