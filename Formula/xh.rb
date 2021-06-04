class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "07d63045f13a0c77990dfd1132f60d20bfddfd0625df49ee22cf4c7e3b3b46fa"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76b47764123ec23a0e82091e3b5c2fc926e643ef460dd540717d77f44c90b8ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b4f93d602bfa0007be457cfa05e1d21a942c7ae326661c688a4dae16b773e71"
    sha256 cellar: :any_skip_relocation, catalina:      "5526896ca50d5deae19e2a0b3b7e75149c188bd6d5bba4d23ac475594ad538ba"
    sha256 cellar: :any_skip_relocation, mojave:        "eeaf44fcf58098d7f5d860c04661679c1e55f927f11d90afc6383af5245218b8"
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
