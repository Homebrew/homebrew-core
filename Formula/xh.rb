class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "c1fd4f33be96ba1c19580fc66dd9d059a716f00f532a516e159ce9342e50cd43"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6883bfed4baeff32fda41fd65598d5743f755c74c3e78d61fc94d795c457ab81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51caf49e26e66f098d27f0ffcb8f5655c4fa6f8805732388b8ddad6b627b77ff"
    sha256 cellar: :any_skip_relocation, monterey:       "9e38e2511c4666cd05e9af6827b94767131374126a0ed28a1b37df0aee9c5efe"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fcd794e148d73e7b14b9f3261c5fba5b490233f261b1a10d9a4762dfed36e6e"
    sha256 cellar: :any_skip_relocation, catalina:       "b70120b70cd998361f1e6da4d5ca7c2f92d2359e56155fba179dd4277a0aa0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e0780ad19d1e316a81bc2df1bc1577c7ed918ef5ba59cdfff0a621b2fa9fa0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
