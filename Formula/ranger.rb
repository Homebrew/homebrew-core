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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a4d109e42f3146daeb999e613a9cedca98cbd851f98f950f54cfaab5e872c58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a4d109e42f3146daeb999e613a9cedca98cbd851f98f950f54cfaab5e872c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a4d109e42f3146daeb999e613a9cedca98cbd851f98f950f54cfaab5e872c58"
    sha256 cellar: :any_skip_relocation, ventura:        "92e4fd7b02e9314319342a86b176bcb78c902ab326b6db482c653194ec5389df"
    sha256 cellar: :any_skip_relocation, monterey:       "92e4fd7b02e9314319342a86b176bcb78c902ab326b6db482c653194ec5389df"
    sha256 cellar: :any_skip_relocation, big_sur:        "92e4fd7b02e9314319342a86b176bcb78c902ab326b6db482c653194ec5389df"
    sha256 cellar: :any_skip_relocation, catalina:       "92e4fd7b02e9314319342a86b176bcb78c902ab326b6db482c653194ec5389df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4d109e42f3146daeb999e613a9cedca98cbd851f98f950f54cfaab5e872c58"
  end

  depends_on "python@3.11"

  def python
    Formula["python@3.11"].opt_libexec/"bin/python"
  end

  def install
    system python, *Language::Python.setup_install_args(prefix, python), "--install-data=#{prefix}"
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
