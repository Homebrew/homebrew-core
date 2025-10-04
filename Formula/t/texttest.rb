class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/50/d2/5ac2d5f53a6b4b72d8485796b9abfa29a8bedd0c4ca08341a382425a49f8/texttest-4.4.5.tar.gz"
  sha256 "99243585979f016c2c89a38a3a3c61e942e13574fb19dd2c933261a3255daaba"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66f16f943aa8fe6b1ad79a04085956d16233c41a504bbb5028292cbeb9070800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd820c229e7f64032d0649fd26d43e55c81dbee638e299e701f59a0c032c168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35373fbc2123caf15748dee0554392b4b99fb4e2fdf9bdb7f8831b03118b8b44"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ca959231bd724c3413be77f68c0fde51b17b542d38e1a0f4546a309c850d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "334a14d5dc1e681139b9040f7726c64bdab6d688705775858f457ff78f8ed20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716562ae9bd735808749541e51b31f457669be0b69911b284627444a41678461"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
