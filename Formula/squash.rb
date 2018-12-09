class Squash < Formula
  desc "Compression abstraction library and utilities"
  homepage "https://quixdb.github.io/squash/"
  url "https://github.com/Demacr/squash/releases/download/v0.8.0/squash.zip"
  sha256 "4ea9be3c74d611e05a7975ba65acd511196ba0283fcf327523a5c620cc195f00"
  depends_on "cmake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "false"
  end
end
