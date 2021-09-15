class Xmlsh < Formula
  desc "XML shell"
  homepage "http://www.xmlsh.org"
  url "https://downloads.sourceforge.net/project/xmlsh/xmlsh/1.2.5/xmlsh_1_2_5.zip"
  sha256 "489df45f19a6bb586fdb5abd1f8ba9397048597895cb25def747b0118b02b1c8"

  livecheck do
    url :stable
    regex(%r{url=.*?/v?(\d+(?:\.\d+)+)/xmlsh}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9a08dc3cd955e21c5e170cb205584b19cf67d10f062a597bc6284ffca9dbc70"
  end

  depends_on "openjdk@11"

  def install
    rm_rf %w[win32 cygwin]
    libexec.install Dir["*"]
    chmod 0755, libexec/"unix/xmlsh"

    env = Language::Java.overridable_java_home_env("11")
    env["XMLSH"] = libexec
    (bin/"xmlsh").write_env_script libexec/"unix/xmlsh", env
  end

  test do
    output = shell_output("#{bin}/xmlsh -c 'x=<[<foo bar=\"baz\" />]> && echo <[$x/@bar]>'")
    assert_equal "baz\n", output
  end
end
