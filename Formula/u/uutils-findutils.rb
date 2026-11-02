class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://uutils.github.io/findutils/"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.11.0.tar.gz"
  sha256 "43d1fbb69a0e67e708435bd104966d1dd61357755452b733db9dabfd66cbf974"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "96d290926be7ea57e8a7a4e2ab2d6a918df021ad817dd96891f0709420579b2c"
    sha256 cellar: :any, arm64_tahoe:       "f0b963f1e968acadb40faf068299ff3d95d1141bb6a92b4014183cc001957333"
    sha256 cellar: :any, arm64_sequoia:     "0ff84ee54e9adce4fac0eb5ec3c013eb6ce4e5f625a3b6d20cdb476e55ab38bf"
    sha256 cellar: :any, arm64_sonoma:      "8f7b577688da476a71ee7f1e3e87457e73871cf38ae07aefe223ac3ed190ad47"
    sha256 cellar: :any, sonoma:            "09f853a5fc9dae2cf13dc059d1e77126744b764a45ec94279709185442f1d47d"
    sha256 cellar: :any, arm64_linux:       "f529b71887accd0166c7267a85bfbe978dcd420df91071026e9d2b26a1984919"
    sha256 cellar: :any, x86_64_linux:      "ba0a289490eae870ea1ef1390d0c842cf87992e009d2616af029db57f877f717"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      next if unwanted_bin_link? cmd

      bin.install_symlink libexec/"uubin"/cmd => "uu-#{cmd}"
    end
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    require "utils/linkage"

    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/uu-find .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/uubin/find .")

    expected_linkage = {
      libexec/"uubin/find" => [
        formula_opt_lib("oniguruma")/shared_library("libonig"),
      ],
    }
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end
