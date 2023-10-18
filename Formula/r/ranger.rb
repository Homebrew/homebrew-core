class Ranger < Formula
  include Language::Python::Shebang

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.3.tar.gz"
  sha256 "ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eea9359688d3ebaf9673aa35279778e16fdd977446ba6d0e8bef5a7bfe8aadc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0861bca3b40f43d04603621ac2862a9fa24cf76149fa3bf98e701b074fac4f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602e6439d7dd6b29ac631e7ac60d04079d898e56b099a614970eb8343b28f5a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "854b27af8c3fbaed381c35078026a685c84b04067bd5437de657c7a6b42d6426"
    sha256 cellar: :any_skip_relocation, ventura:        "a03c4e877b00a78bc49ad03be5aac198350e8eb9456672cfb7b5df3f24f705dd"
    sha256 cellar: :any_skip_relocation, monterey:       "45fd5e64d17483293b05ff8b376e2d4b081073279c8542ef375252d3c077d939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2faf4fe8116fc48ba789940320882c5bed58b7c5900e827200021f38d62c83"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python
    Formula["python@3.12"].opt_libexec/"bin/python"
  end

  def install
    system python, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")

    code = "print('Hello World!')\n"
    (testpath/"test.py").write code
    assert_equal code, shell_output("#{bin}/rifle -w cat test.py")

    ENV.prepend_path "PATH", python.parent
    assert_equal "Hello World!\n", shell_output("#{bin}/rifle -p 2 test.py")
  end
end
