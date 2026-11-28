class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "9f07f6a20adb958acd85b94bdc28895f17dc6773cf95fbc841fabd23eddbcb83"
  license "MIT"

  bottle do
    manifest_sha256 "5dda0f32c2c83bc6dcc454ea6437aefc05ac596c503efc0f63d9df9c61af5654"
    sha256 cellar: :any_skip_relocation, all: "4c61111d4684116bc5b2d5fe52cef541cf20d77bded17b3336d4778adba7e47b"
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
