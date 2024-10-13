class Ranger < Formula
  include Language::Python::Virtualenv

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.3.tar.gz"
  sha256 "ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d658a012014c41c2ff480390de60f9b7d14de34e7f207bd22646a44944ba4ef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6e82a85ac9ec491664b30f4023e2c96be0485eec8fc34bae355500bd6e87024"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7df758964227f9f43b50b30e80eb8c2c54f0f0926806b4912de077631e59644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6a5f3323c38e5b7cd70ddaee2a29fb1d2f9a68ac690a2aea8eda06baea2c8f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3efb7ed3317ce5187e6cab149b54504f15a7cf32e0a7f156dbde05867f966a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "86a9399e36ac5cba36a307a951f5ae5f7cce3ac697eaa06c73674f565bfb4253"
    sha256 cellar: :any_skip_relocation, monterey:       "e26848ccdb553fb6914c4165c5985b6d0c25c7df2df21a61d176608a14d923c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c019d60c241b2080cd53ad4fc8e24bb8c14df3345d09a4f202a798d51a1a8e"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")

    code = "print('Hello World!')\n"
    (testpath/"test.py").write code
    assert_equal code, shell_output("#{bin}/rifle -w cat test.py")

    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"
    assert_equal "Hello World!\n", shell_output("#{bin}/rifle -p 2 test.py")
  end
end
