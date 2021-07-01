class RofsFiltered < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "250c65163e46fc9eaaab11b27562c70775f2481cfe9f649ab151f8da3616ff08"
    sha256 cellar: :any, mojave:      "6f220b4a193928a97dc8442cadf6d161224a1ddac098d496c8cf9a20fb7cd02a"
    sha256 cellar: :any, high_sierra: "74277c4f4cc2c60534cda38627450176f356da5bb7120334fd667eaa261fea7b"
  end

  depends_on "cmake" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
      system "make", "install"
    end
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
end
