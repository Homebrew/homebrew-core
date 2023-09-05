class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.4.2.tar.gz"
  sha256 "b02fce9219393b47384229b397c7fbe479435ae8ccf8947f4b6cf7ac159d80f9"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46c3776daae394601d7bbe347a624b40aec9d980e6670cbaf4281377d3c9f8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5676fc52e1c936b9c4c0d7e05a0dcbe941ab36f9f42c45500ab59329946034a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd8dbcce4cde5f848b8fdacd58fcc7f49feb06960c91e994308e6a66837be7c0"
    sha256 cellar: :any_skip_relocation, ventura:        "3b12831cd03483b5a11a08f899261b55325649110652916e309e5592f7205165"
    sha256 cellar: :any_skip_relocation, monterey:       "757cb5575ac4a797d11fc9e7b47c82faf20303f8e2942f8ac3845fb564ec123d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b92ef5601c1730634241e4127797be3e74a9859847e2571360b0503a2ccb6ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ce4cb813793fe4d60014fc621a9e74ff93c6c1f3eb3f0217423d5e8ed120d4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "llvm@15" => :build
  end

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm@15"].opt_lib.to_s if OS.linux?
    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      bin.install_symlink libexec/"uubin"/cmd => "u#{cmd}" unless unwanted_bin_link? cmd
    end
  end

  def caveats
    <<~EOS
      Commands also provided by macOS have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/ufind .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/uubin/find .")
  end
end
