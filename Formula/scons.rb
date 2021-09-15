class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/5e/f1/82e5d9c0621f116415526181610adf3f9b07ffca419620f4edfc41ef5237/SCons-4.2.0.tar.gz"
  sha256 "691893b63f38ad14295f5104661d55cb738ec6514421c6261323351c25432b0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "13c816bd6916bd07503eef1b9b12788a9eb09469f6c54b9fb1a8e58ab084a82a"
    sha256 cellar: :any_skip_relocation, big_sur:       "09a2320d3cc8fa3d720507cb06e8e7eafe0e6d582c18fb4832e8d7a5491b961a"
    sha256 cellar: :any_skip_relocation, catalina:      "09a2320d3cc8fa3d720507cb06e8e7eafe0e6d582c18fb4832e8d7a5491b961a"
    sha256 cellar: :any_skip_relocation, mojave:        "09a2320d3cc8fa3d720507cb06e8e7eafe0e6d582c18fb4832e8d7a5491b961a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87be85481d3a954f2e7ac8a838fe0032dc5d0ff88bbf9db2a6f3b9c004957732"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
