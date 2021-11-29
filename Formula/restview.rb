class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/30/c8/c4907d4691571f1a3c829be6b14ae2a6029a2c4c899612b84f580a6183e7/restview-2.9.3.tar.gz"
  sha256 "5951aa2182e7a9aa3ab906dbd0f0d33df8fe93e66318a8689649c1228ad74cd8"
  license "GPL-3.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ac7dd627e9564db2ea168ebab81fe6a857603ccb9400e3259b99e4e84ff6dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb2eeee507bc57c0b8ea4daaa09beb5953ed23c6368279e0965d5db83da851d6"
    sha256 cellar: :any_skip_relocation, monterey:       "c055e05f3a46f9ea28a97036987db6caca52c91412f34a20b7f4f9db45e2c1ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9470d4f0e710da0bda1cb188f6a26ea8300fad4273c67d8362b95655a3131436"
    sha256 cellar: :any_skip_relocation, catalina:       "51774d5ba45376854bbccc90a94252cedc5c7e22efbe933305aa55c077a755ed"
    sha256 cellar: :any_skip_relocation, mojave:         "9afe08d8d8f8f4cd5a64e2de7af17eff2de637442feccdedb36320afb8a0deb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deffb0171b3411a93bac2ffa760adbcdf7939592f052c1bed930cc21946f05cf"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6a/a3/217842324374fd3fb33db0eb4c2909ccf3ecc5a94f458088ac68581f8314/bleach-4.1.0.tar.gz"
    sha256 "0900d8b37eba61a802ee40ac0061f8c2b5dee29c1927dd1d233e075ebf5a71da"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/cb/a5/9d2333bd020bb1979ba51ab5acf59d77559951405e024e49576b5bee1a90/readme_renderer-30.0.tar.gz"
    sha256 "8299700d7a910c304072a7601eafada6712a5b011a20139417e1b1e9f04645d8"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.rst").write <<~EOS
      Lists
      -----

      Here we have a numbered list

      1. Four
      2. Five
      3. Six
    EOS

    port = free_port
    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 3
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end
