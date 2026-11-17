class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "9f07f6a20adb958acd85b94bdc28895f17dc6773cf95fbc841fabd23eddbcb83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d041d1486a6bcb2502e58088c308dde7e358e017a0428683674c4d1b6aa4a6e5"
  end

  uses_from_macos "ruby" => :build
  uses_from_macos "zsh" => :test

  deny_network_access!

  def install
    ENV["ZIMFW_VENDOR"] = tap.user
    system "make", "-B"
    share.install "zimfw.zsh"
  end

  def caveats
    <<~EOS
      zimfw.zsh lives in #{opt_share}/zimfw.zsh to source in your .zshrc.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh version'")
    assert_match "zimfw version:        #{version} (#{tap.user})",
      shell_output("zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh info'")

    (testpath/".zimrc").write("zmodule test --use mkdir --on-pull '>init.zsh <<<\"print test\"'")
    system "zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh init -q'"
    assert_path_exists testpath/".zim/modules/test/init.zsh"
    assert_path_exists testpath/".zim/init.zsh"
  end
end
