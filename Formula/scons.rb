class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/7f/1e/7ec69d54762bc2d41e85d461548e8a35011c3626173f8472f05411b79a3f/SCons-4.5.1.tar.gz"
  sha256 "9daeabe4d87ba2bd4ea15410765fc1ed2d931b723e4dc730a487a3911b9a1738"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81933b7a1286916f5a1eab0d02452bfb811b57e7bb7a92350112513008a474e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617233bece312a721314ebb3769d3a617de6078d480e1f1e9831ef3ab69b0a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b8ca5a5d54f26f428deb4c1f1159ece390a53a320edcdd0f5794a5c74c97113"
    sha256 cellar: :any_skip_relocation, ventura:        "3029822fe92e48ab3932640ee81ddb528c68b1f07d75052150f045d4c9ed903b"
    sha256 cellar: :any_skip_relocation, monterey:       "40894305ec345b2b4c3395ac13d6dbf5905f4d79fee3e40a73588b92632a071e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ce14ecf17b8cb96fc728e4adb5fd33416de34210923249cf547b57b38d72467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a72bcd1a60dde850f359e5668be2c11980d98ac53cb4dfca8356484a6297b3f"
  end

  depends_on "python@3.11"

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
