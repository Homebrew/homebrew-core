class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "5edf426895cad99c7fd6486de6618e7360ebcdbdda0684b78d587d67b4749345"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "main"

  bottle do
    manifest_sha256 "f592e52187ab11fa5429056417a74f16cb9b6fc6eb56b879860afb2dfdb00437"
    sha256 cellar: :any_skip_relocation, all: "157dc6d8f92431bf3084c0ce8b8f78149299ad308b17ca23df5235622213565c"
  end

  deny_network_access!

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
