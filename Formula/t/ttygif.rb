class Ttygif < Formula
  desc "Converts a ttyrec file into gif files"
  homepage "https://github.com/icholy/ttygif"
  url "https://github.com/icholy/ttygif/archive/refs/tags/1.6.0.tar.gz"
  sha256 "050b9e86f98fb790a2925cea6148f82f95808d707735b2650f3856cb6f53e0ae"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c2801e9fd3037e19b2505cf7d066fc65d08970895db9df569bdaadfe72b6dea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1677ae4c695a79d31461441374113ef860629ba4670f35232aefe2fd22ac932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a1d592292b40738d6ec36a627aa460861b6534b836e205ea197eba6eafb1e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c912d39e94ccc7732340d50660b7de8253b615ae256e3abcd8b14abcb7e5b167"
    sha256 cellar: :any,                 arm64_linux:   "9b33a027b0e482b5c56f047f037e77988d3bb52b19c8d5feb05499b8de0ceba3"
    sha256 cellar: :any,                 x86_64_linux:  "2faf0bb18bfa73230fe00e07f95b4673a12dfb987b1245454268ca006f53f599"
  end

  depends_on "imagemagick"
  depends_on "ovh-ttyrec"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Work around "Error: WINDOWID environment variable was empty."
    # Lighter weight alternative to adding a mock display.
    ENV["WINDOWID"] = "0" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["TERM_PROGRAM"] = "Something"
    system bin/"ttygif", "--version"
  end
end
