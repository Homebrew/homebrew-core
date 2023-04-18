class StormsshCompletion < Formula
  desc "Completion for storm-ssh"
  homepage "https://github.com/vigo/stormssh-completion"
  url "https://github.com/vigo/stormssh-completion/archive/0.1.1.tar.gz"
  sha256 "cbdc35d674919aacc18723c42f2b6354fcd3efdcbfbb28e1fe60fbd1c1c7b18d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e0ce84c379316e6e7b59a49f9c57b1accd69d4945f730878882ecf0d05420b9b"
  end

  deprecate! date: "2022-11-28", because: "stormssh is deprecated"

  def install
    bash_completion.install "stormssh"
  end

  test do
    assert_match "-F __stormssh",
      shell_output("bash -c 'source #{bash_completion}/stormssh && complete -p storm'")
  end
end
