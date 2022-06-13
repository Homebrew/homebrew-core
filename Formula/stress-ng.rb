class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.02.tar.gz"
  sha256 "30dd0ec5799b717fe416a46c314869f26c456b7c05e7498d9c36affe1e9f0d18"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43f0213982bb72e42c2f9dd4b1e1aaf7882d9d46083628577ce7a00ba77742d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "931e90bbf1ac2bef57779d9a530e9dcafaf6d3e0af1288be2c3df6ecf6498393"
    sha256 cellar: :any_skip_relocation, monterey:       "317ae7333ad61144ffe2f3357d876362a235d78a4f7b674949d4281378c342b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7f57e2e0a06e2acb14d452f0edb4df7c1da06498f6499de4b51f3bbd13f3f30"
    sha256 cellar: :any_skip_relocation, catalina:       "edd37d3c1b7cef2060efab462b1f284b341815e0ff989d59acf09634e7d3d82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f2387b9517035b0adc1e7781cdea35e1a349701f438061eb8a02af8aec38680"
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
