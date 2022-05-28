class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.13.0",
      revision: "1705d14b8fef5ebb826a74549d609c6ab6cb63f7"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  bottle do
    sha256 cellar: :any, catalina:    "8a8c7dd74f9b3082b2b128cc058714a27206d910273e4148959a25b7d30c51b5"
    sha256 cellar: :any, mojave:      "9bee23af87518f68df56b862ad0ef88f842ebe65f8feff02e90bf5ab8e91522e"
    sha256 cellar: :any, high_sierra: "632496d8e9ed9fe91d18e9a2c9fef49c920dc091e10108246f8ab2056f75ea38"
  end

  depends_on "cmake" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
