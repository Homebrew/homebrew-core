class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/v2.7.1.tar.gz"
  sha256 "0062dcbc62658dd2e4361e97d1ec12602f4a6661e771b730158e615aff3ea695"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58b4ea1342a5e9c2f8c52ac95be0df7fa757d962026707d950d32b0481d99b84"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
