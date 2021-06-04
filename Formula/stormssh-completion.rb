class StormsshCompletion < Formula
  desc "Completion for storm-ssh"
  homepage "https://github.com/vigo/stormssh-completion"
  url "https://github.com/vigo/stormssh-completion/archive/0.1.1.tar.gz"
  sha256 "cbdc35d674919aacc18723c42f2b6354fcd3efdcbfbb28e1fe60fbd1c1c7b18d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23295d6470ff83ce4b42bfa96681254398d672bf15cb9c78baa4c6979659fc7d"
  end

  def install
    bash_completion.install "stormssh"
  end

  test do
    assert_match "-F __stormssh",
      shell_output("source #{bash_completion}/stormssh && complete -p storm")
  end
end
