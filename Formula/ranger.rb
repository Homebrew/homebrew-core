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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a8e823cd40ee0b37e7b33327de1d4c55d8558d20abd380b3df1b47544bb327e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2972a3ffed7cb61dcd1abe64cb6d24b902ffc50ef78e10fc279ebda56175a1d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2972a3ffed7cb61dcd1abe64cb6d24b902ffc50ef78e10fc279ebda56175a1d8"
    sha256 cellar: :any_skip_relocation, monterey:       "12656acfac655b9a648d8cb877ef38fd6ef644f74cb182cff4075b333523d996"
    sha256 cellar: :any_skip_relocation, big_sur:        "12656acfac655b9a648d8cb877ef38fd6ef644f74cb182cff4075b333523d996"
    sha256 cellar: :any_skip_relocation, catalina:       "12656acfac655b9a648d8cb877ef38fd6ef644f74cb182cff4075b333523d996"
    sha256 cellar: :any_skip_relocation, mojave:         "12656acfac655b9a648d8cb877ef38fd6ef644f74cb182cff4075b333523d996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2972a3ffed7cb61dcd1abe64cb6d24b902ffc50ef78e10fc279ebda56175a1d8"
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
