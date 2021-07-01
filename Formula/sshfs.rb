class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.1.tar.gz"
  sha256 "0f0f8f239555effd675d03a3cabfb35ef691a3054c98b62bc28e85620ad9e30d"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any, catalina:    "aceff3131dd0b098bdef8b5dda54d117b5dd5269ca146f7a5032ecde3c99b6d2"
    sha256 cellar: :any, mojave:      "5f69267c0f1f2489989e108919d66210e058423d0d1f1661812c0194b164619c"
    sha256 cellar: :any, high_sierra: "58d222f37622b399352f16eaf823d3e564445d9e951629e965281ac31de5ef4a"
    sha256 cellar: :any, sierra:      "dc4a7f24c2cbebd7c35891200b043d737ba6586a28992708ef849ffedff7bb01"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfuse"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  def install
    mkdir "build" do
      system "meson", ".."
      system "meson", "configure", "--prefix", prefix
      system "ninja", "--verbose"
      system "ninja", "install", "--verbose"
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

  test do
    system "#{bin}/sshfs", "--version"
  end
end
