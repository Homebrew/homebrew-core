class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.5.0.tar.gz"
  sha256 "d4864169dca54e44c1f3a6f09bcf5048190e6a97ee0a9887437dbc7f5ed6aaaa"

  depends_on "rust" => :build

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    # Update when https://github.com/sharkdp/vivid/blob/master/ci/before_deploy.bash changes.
    pkgshare.install "config/filetypes.yml", "themes"
  end

  # Hardcoded to /usr/share/vivid or $HOME/.config/vivid, doesn't check XDG_CONFIG_HOME.
  def caveats
    <<~EOS
      To use Vivid you need to link the vivid share directory to ~/.config/vivid by running:

        mkdir -p ~/.config
        ln -sf #{HOMEBREW_PREFIX}/share/vivid ~/.config/vivid
    EOS
  end

  test do
    assert_match "vivid #{version}", shell_output("#{bin}/vivid --help")
  end
end
