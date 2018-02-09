class Restview < Formula
  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://github.com/mgedmin/restview/archive/2.8.1.tar.gz"
  sha256 "9dda3adc3f4c73a97617eb049428df89e2a4b39fca357ba2025f4d6898f2c0c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb887c352198ea2ada802c82a5ae106772e0ad19146d8a2cc32c8505c4fd40c" => :high_sierra
    sha256 "5bb887c352198ea2ada802c82a5ae106772e0ad19146d8a2cc32c8505c4fd40c" => :sierra
    sha256 "2e83c1b3df9aa3ce2e32095e09efca96754c500c92255031e83a8ccdfacb473a" => :el_capitan
  end

  depends_on python if MacOS.version <= :snow_leopard

  if MacOS.version <= :el_capitan
    resource "setuptools" do
      url "https://files.pythonhosted.org/packages/6c/54/f7e9cea6897636a04e74c3954f0d8335cc38f7d01e27eec98026b049a300/setuptools-38.5.1.zip"
      sha256 "6425484c08e99a98a42209c25c3d325f749230b55284d66192784f941a7e6628"
    end
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/b3/5f/0da670d30d3ffbc57cc97fa82947f81bbe3eab8d441e2d42e661f215baf2/bleach-2.1.2.tar.gz"
    sha256 "38fc8cbebea4e787d8db55d6f324820c7f74362b70db9142c1ac7920452d1a19"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "readme_renderer" do
    url "https://files.pythonhosted.org/packages/b6/a8/f27c15837fcbcb6110bd0f1dfa04b5fae658a1da3c07f186dba89818a613/readme_renderer-17.2.tar.gz"
    sha256 "9deab442963a63a71ab494bf581b1c844473995a2357f4b3228a1df1c8cba8da"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "sample" do
    url "https://raw.githubusercontent.com/mgedmin/restview/140e23ad6604d52604bc11978fd13d3199150862/sample.rst"
    sha256 "5a15b5f11adfdd5f895aa2e1da377c8d8d0b73565fe68f51e01399af05612ea3"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = resources.reject { |r| r.name == "sample" }

    res.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    testpath.install resource("sample")

    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 1
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end
