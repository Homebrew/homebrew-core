class RakeCompletion < Formula
  desc "Bash completion for Rake"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby.git",
    :revision => "710d0699ee710e181da90c4f3af8b39e4b5c81de"
  version "2"

  head "https://github.com/mernen/completion-ruby.git"

  bottle :unneeded

  def install
    bash_completion.install "completion-rake" => "rake"
  end

  test do
    assert_match "-F __rake",
      shell_output("source #{bash_completion}/rake && complete -p rake")
  end
end
