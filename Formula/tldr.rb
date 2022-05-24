class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.4.3.tar.gz"
  sha256 "273d920191c7a4f9fdd9f2798feacc65eb5b17f95690a90b6901e8c596900d9d"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "344e2ca81daebdcba97e90441c79de2c0e6a24b83ff26eefc01eb0a11d6e6e09"
    sha256 cellar: :any,                 arm64_big_sur:  "2651f9115abb83c9f8738e0cb6d0bd72e78cc322261313e00cb6fc564be983dc"
    sha256 cellar: :any,                 monterey:       "aeb51aa37519baa0c187b8da06b394dcb9e60fd243004d24a011785a26fb6d04"
    sha256 cellar: :any,                 big_sur:        "d6f79989e34283228b474d8fae394d6be6e46906b51a4b98b0c2f427ddd8dc69"
    sha256 cellar: :any,                 catalina:       "03dd86a23d77135aa39dcdd7b4bc234fb584209a036343c8f06f442ebd0cab85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c003099b08ebbf65487571bb0fe2617bf238a6ef3d60f521d21c31a6a809cd5"
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
