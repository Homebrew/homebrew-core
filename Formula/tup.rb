class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.11.tar.gz"
  sha256 "be24dff5f1f32cc85c73398487a756b4a393adab5e4d8500fd5164909d3e85b9"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe803cdb793a0521d4b711bbbdb150d404916e997dfba17146390219910f3383"
  end

  depends_on "pkg-config" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
    doc.install (buildpath/"docs").children
    pkgshare.install "contrib/syntax"
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
    system "#{bin}/tup", "-v"
  end
end
