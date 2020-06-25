class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
    :revision => "bb0eb6a80a7aaa04aa7fe038c7f824a535933fe9",
    :tag      => "v0.8.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ba2c8d9d50b726a5340ecd1ba4d90ed7cebc52f1b719d210e9bf3972d68f88a" => :catalina
    sha256 "55d1016c0fbd7e9e06907567e80e215847889a7e9bd8bf99a2668d5397fbe4d1" => :mojave
    sha256 "f24ef90f70371e74a5bd3d5dac5f56c11421c24d42479322acd6fc7c2b462a36" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
