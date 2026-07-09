class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/30/11/5b6c9ce24c1b23effa0db201babf7610f15a98ecf6a7c3a00fa68db7a1fe/texttest-4.4.7.tar.gz"
  sha256 "448d7f2d5c2883841df421d84b325b90067c0d385c4d6a700a6fd1cbe0972318"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "832571055ac92ca8238bc82f577cd7c79523ad2e2193e52ab854b9a7527025f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc868e7faed48bee9913df824bed353d7caaaee13b9df1e1b2c14c556c28d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5b90f947bf17649646c87dd493ee7cda94ead006751078c4ec2d156631ac454"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a615e5b8b7c3a1612d113e7f73d9e182bdc5990149250ccd76820e748832d6"
    sha256 cellar: :any,                 arm64_linux:   "4fb5d327bc22b864041d1c8664e64a6949a9f3c810f8498db9b530b75e3a0f0b"
    sha256 cellar: :any,                 x86_64_linux:  "4465570b8c8ba4cad53ce566e8a46c481036831ca62fd9dac1b9a87a4346d021"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.14"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
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
