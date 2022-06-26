class RofsFiltered < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"
  license "GPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a07f54de644092a439c5ae5a537aca17499ea8b1dad446bb1610f1fb30aaf5cf"
  end

  depends_on "cmake" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
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
