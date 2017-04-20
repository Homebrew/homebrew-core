class StormsshCompletion < Formula
  desc "Completion for storm-ssh"
  homepage "https://github.com/vigo/stormssh-completion"
  url "https://github.com/vigo/stormssh-completion/archive/0.1.1.tar.gz"
  sha256 "cbdc35d674919aacc18723c42f2b6354fcd3efdcbfbb28e1fe60fbd1c1c7b18d"

  bottle :unneeded

  def install
    bash_completion.install "stormssh"
  end

  test do
    assert_match "-F __stormssh",
      shell_output("source #{bash_completion}/stormssh && complete -p storm")
  end
end
