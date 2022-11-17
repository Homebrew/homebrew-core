class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.5.0.tar.gz"
  sha256 "8e3f0c3f471896f8cfadbf9000aa8f2eff61fc3d76e25203ddc7640331c2a2af"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a522c4962d9b00b2ae0d9500ed1fb4cfccdaba0592b8211159aa874b146a01b9"
    sha256 cellar: :any,                 arm64_monterey: "3f969a50b717145b7711c699aeff9290e98c43833a9e9d01119fa5c22c87b861"
    sha256 cellar: :any,                 arm64_big_sur:  "c0fa874b41e4f1a9e6e597bd8cb462f4f0180aae9844f0e9154e778c1e030ee9"
    sha256 cellar: :any,                 ventura:        "fea2a586a40d78f69eab2c8db3f5bf08805635f4978db148795b6fece7fff425"
    sha256 cellar: :any,                 monterey:       "79b6fb23aadf46144c104d3c53ea8cae750f8475bd4ff09be6f498fda0f83016"
    sha256 cellar: :any,                 big_sur:        "bbb0d3d550e2e55c1a0b3bbe48aca47995b988940ae5a05633fd515793a31cf2"
    sha256 cellar: :any,                 catalina:       "639a83243ed67d2d6294882b56ad0706526e6d50d837e85379fcb4f65e63abca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948fa2f4233dc829670e11d5eed35ac8180383d3629bd3090761bf6ca3e9a767"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  uses_from_macos "curl"

  conflicts_with "tealdeer", because: "both install `tldr` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    bash_completion.install "autocomplete/complete.bash" => "tldr"
    zsh_completion.install "autocomplete/complete.zsh" => "_tldr"
    fish_completion.install "autocomplete/complete.fish" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
