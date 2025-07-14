class Ranger < Formula
  include Language::Python::Virtualenv

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://github.com/ranger/ranger/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "7ad75e0d1b29087335fbb1691b05a800f777f4ec9cba84faa19355075d7f0f89"
  license "GPL-3.0-or-later"
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ec1aa9eb07127348df0acbbe74ee70530e3c42b2b34b318d275a5b939b108c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ec1aa9eb07127348df0acbbe74ee70530e3c42b2b34b318d275a5b939b108c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97ec1aa9eb07127348df0acbbe74ee70530e3c42b2b34b318d275a5b939b108c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9805b7b6198dac4993bf90919395a37d7e26dea6c1a059c87a82f30c56b915af"
    sha256 cellar: :any_skip_relocation, ventura:       "9805b7b6198dac4993bf90919395a37d7e26dea6c1a059c87a82f30c56b915af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25694caeb635a9e43026ce07350d8d0bbaef2ffa959e910dde876f97e32959c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ec1aa9eb07127348df0acbbe74ee70530e3c42b2b34b318d275a5b939b108c"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")

    code = "print('Hello World!')\n"
    (testpath/"test.py").write code
    assert_equal code, shell_output("#{bin}/rifle -w cat test.py")

    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"
    assert_equal "Hello World!\n", shell_output("#{bin}/rifle -p 2 test.py")
  end
end
