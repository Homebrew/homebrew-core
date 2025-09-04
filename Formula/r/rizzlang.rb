class Rizzlang < Formula
  desc "Rizz++ - small GenZ-style toy language"
  homepage "https://github.com/Sriyush/RizzLang"
  url "https://github.com/Sriyush/RizzLang/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "d9af95a6cbe8cf2ae9078bb0315acefb6e6c6569da305594a3e32c9197bfbef4"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-15"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-15"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/rizz", "--version"
  end
end
